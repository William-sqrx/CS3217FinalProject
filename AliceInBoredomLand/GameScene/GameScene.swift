//
//  GameScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

final class HeroRenderer {
    static func makeNode(from model: HeroModel) -> SKSpriteNode {
        let textureName: String = {
            switch model.type {
            case .archer:
                return "archer"
            case .swordsman:
                return "swordsman"
            case .tank:
                return "tank"
            }
        }()

        let node = SKSpriteNode(texture: SKTexture(imageNamed: textureName))
        node.size = model.physics.size
        node.position = model.position

        let body = SKPhysicsBody(rectangleOf: model.physics.size)

        body.isDynamic = model.physics.isDynamic
        body.categoryBitMask = model.physics.categoryBitMask
        body.contactTestBitMask = model.physics.contactTestBitMask
        body.collisionBitMask = model.physics.collisionBitMask
        body.affectedByGravity = false
        body.allowsRotation = false
        node.physicsBody = body

        node.userData = ["entityId": model.id]

        return node
    }
}

final class MonsterRenderer {
    static func makeNode(from model: MonsterModel) -> SKSpriteNode {
        let node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

final class PlayerCastleRenderer {
    static func makeNode(from model: GameCastleModel) -> SKSpriteNode {
        let node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

final class EnemyCastleRenderer {
    static func makeNode(from model: GameCastleModel) -> SKSpriteNode {
        let node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

class GameScene: SKScene {
    var gameLogicDelegate: GameLogicDelegate
    var entities: [GameEntity] = []
    var tasks: [Task] = []
    var frameCounter = 0
    var monsterModels: [UUID: MonsterModel] = [:]
    var monsterNodes: [UUID: SKSpriteNode] = [:]
    var heroModels: [UUID: HeroModel] = [:]
    var heroNodes: [UUID: SKSpriteNode] = [:]
    var castleModels: [UUID: GameCastleModel] = [:]
    var castleNodes: [UUID: SKSpriteNode] = [:]

    // Please use getNodeSize instead of this directly
    let tileSize = CGSize(width: width / Double(numCols),
                          height: (height - rowSpacing * Double(numRows - 1)) / Double(numRows))

    init(gameLogicDelegate: GameLogicDelegate,
         background: SKColor = .gray,
         size: CGSize = CGSize(width: GameScene.width, height: GameScene.height)) {
        self.gameLogicDelegate = gameLogicDelegate
        self.entities = []
        super.init(size: size)
        self.backgroundColor = background
        self.scaleMode = .aspectFit
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Todo: Rework in a format that allows for actually using currentTime, instead of assuming even time steps
    override func update(_ currentTime: TimeInterval) {
        frameCounter += 1

        if frameCounter.isMultiple(of: 30) {
            performFrameLogic()
        }

        updateProjectiles()
    }

    private func performFrameLogic() {
        let deltaTime: TimeInterval = 1.0
        let frameIndex = frameCounter / 30

        if frameIndex % 2 == 1 {
            updateHeroes(deltaTime: deltaTime)
        } else {
            // New: update decoupled monster models
            updateMonsters(deltaTime: deltaTime)
        }

        tasks.forEach { $0.update(deltaTime: deltaTime) }

        if frameIndex % 6 == 1 {
            spawnTask()
        }

        checkWinLose()
        removeDeadEntities()
    }

    private func updateProjectiles() {
        entities.compactMap { $0 as? Arrow }.forEach { $0.updateArrow(deltaTime: 1.0) }
    }

    private func checkWinLose() {
        guard let logic = gameLogicDelegate as? GameLogic else {
            return
        }

        if logic.monsterCastleHealth <= 0 {
            showEndGameLabel(text: "You Win 🎉")
            isPaused = true
            return
        }

        if logic.playerCastleHealth <= 0 {
            showEndGameLabel(text: "You Lose 💀")
            isPaused = true
            return
        }
    }

    private func showEndGameLabel(text: String) {
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Avenir-Heavy"
        label.position = CGPoint(x: GameScene.width / 2, y: GameScene.height / 2 + 50)
        label.name = "end_game_label"
        addChild(label)

        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontSize = 30
        restartLabel.fontColor = .yellow
        restartLabel.fontName = "Avenir"
        restartLabel.position = CGPoint(x: GameScene.width / 2, y: GameScene.height / 2 - 50)
        restartLabel.name = "restart_button"
        addChild(restartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPaused else {
            return
        }

        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "restart_button" {
                restartGame()
            }
        }
    }

    private func restartGame() {
        guard let view = self.view else {
            return
        }

        if let logic = gameLogicDelegate as? GameLogic {
            logic.reset()
        }

        let newScene = GameScene(gameLogicDelegate: gameLogicDelegate)
        newScene.scaleMode = self.scaleMode
        view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    func spawnHero(atX tileX: Int = 1, atY tileY: Int = 5, type: HeroType) {
        assert(0 < tileX && tileX < GameScene.numCols - 1)
        assert(1 < tileY && tileY < GameScene.numRows)
        guard let logic = gameLogicDelegate as? GameLogic else {
            return
        }

        let position = adjustNodeOrigin(
            node: SKSpriteNode(), // dummy
            position: getPosition(tileX: tileX, tileY: tileY)
        )

        let size = getNodeSize()

        let stats = EntityFactory.getHeroStats(type: type)

        guard logic.mana >= stats.manaCost else {
            print("❌ Not enough mana to spawn \(type)")
            return
        }

        logic.decreaseMana(by: stats.manaCost)

        let (model, node) = EntityFactory.makeHero(type: type, position: position, size: size)
        node.name = "hero"

        heroModels[model.id] = model
        heroNodes[model.id] = node
        addChild(node)
    }

    private func spawnMonster(atX tileX: Int = 8, atY tileY: Int = 5) {
        assert(0 < tileX && tileX < GameScene.numCols - 1)
        assert(1 < tileY && tileY < GameScene.numRows)

        let size = getNodeSize()
        let position = adjustNodeOrigin(
            node: SKSpriteNode(),
            position: getPosition(tileX: tileX, tileY: tileY)
        )

        let (model, node) = EntityFactory.makeMonster(position: position, size: size)
        node.name = "monster"

        monsterModels[model.id] = model
        monsterNodes[model.id] = node
        addChild(node)
    }

    private func spawnPlayerCastle() {
        let size = getNodeSize(numTileY: 5)
        let position = adjustNodeOrigin(
            node: SKSpriteNode(),
            position: getPosition(tileX: 0, tileY: 4)
        )

        let (model, node) = EntityFactory.makeCastle(position: position, size: size, isPlayer: true)
        castleModels[model.id] = model
        castleNodes[model.id] = node
        addChild(node)
    }

    private func spawnEnemyCastle() {
        let size = getNodeSize(numTileY: 5)
        let position = adjustNodeOrigin(
            node: SKSpriteNode(),
            position: getPosition(tileX: GameScene.numCols - 1, tileY: 4)
        )

        let (model, node) = EntityFactory.makeCastle(position: position, size: size, isPlayer: false)
        castleModels[model.id] = model
        castleNodes[model.id] = node
        addChild(node)
    }

    private func spawnTask() {
        let texture = SKTexture(imageNamed: "task")
        let size = getNodeSize()
        let task = Task(texture: texture, size: size)

        task.position = adjustNodeOrigin(node: task,
                                         position: getPosition(tileX: GameScene.numCols - 1, tileY: 1))
        addChild(task)
        tasks.append(task)
    }

    private func removeDeadEntities() {
        entities = entities.filter { entity in
            if !entity.isAlive {
                entity.node.removeFromParent()
                return false
            }
            return true
        }
    }

    func initialiseEntities() {
        spawnPlayerCastle()
        spawnEnemyCastle()
        spawnMonster(atX: 5)
        spawnHero(atX: 3, type: .swordsman)
    }

    private func handleCollisions() {
    }

    override func didMove(to view: SKView) {
        initialiseEntities()
        physicsWorld.contactDelegate = self
        GameModelRegistry.shared.monsterModels = monsterModels
        GameModelRegistry.shared.monsterNodes = monsterNodes
        GameModelRegistry.shared.heroModels = heroModels
        GameModelRegistry.shared.heroNodes = heroNodes
        GameModelRegistry.shared.gameLogicDelegate = gameLogicDelegate
    }
}

extension GameScene {
    func isMonsterInRange(_ archerPosition: CGPoint, range: CGFloat) -> Bool {
        for (_, model) in monsterModels {
            let distance = (model.position - archerPosition).length()
            if distance <= range {
                return true
            }
        }
        return false
    }

    func spawnArrow(from position: CGPoint, damage: Int) {
        let arrow = Arrow(damage: damage)
        arrow.position = position

        // Adjust if needed: shoot toward the right
        let direction: CGFloat = 1
        arrow.physicsBody?.velocity = CGVector(dx: 500 * direction, dy: 0)

        addChild(arrow)
    }

    func updateHeroes(deltaTime: TimeInterval) {
        for (id, var model) in heroModels {
            guard let node = heroNodes[id] else { continue }

            // Decrease knockback timer
            model.knockbackTimer = max(0, model.knockbackTimer - deltaTime)

            if model.knockbackTimer == 0 {
                // Resume forward movement (to the right)
                node.physicsBody?.velocity = CGVector(dx: model.speed, dy: 0)
            }

            // Attack logic (optional)
            if model.type == .archer {
                let currentTime = CACurrentMediaTime()
                if currentTime - model.lastAttackTime > model.attackCooldown {
                    if isMonsterInRange(model.position, range: model.attackRange) {
                        spawnArrow(from: model.position, damage: model.attack)
                        model.lastAttackTime = currentTime
                    }
                }
            }

            // Sync position
            model.position = node.position
            heroModels[id] = model
        }
    }

    func updateMonsters(deltaTime: TimeInterval) {
        for (id, var model) in monsterModels {
            guard let node = monsterNodes[id] else { continue }

            // Decrease knockback timer
            model.knockbackTimer = max(0, model.knockbackTimer - deltaTime)

            if model.knockbackTimer == 0 {
                // Resume forward movement
                node.physicsBody?.velocity = CGVector(dx: -model.speed, dy: 0)
            }

            // Sync model position back
            model.position = node.position
            monsterModels[id] = model
        }
    }
}
