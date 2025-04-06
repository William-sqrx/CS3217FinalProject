//
//  LevelScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

final class HeroRenderer {
    static func makeNode(from model: HeroModel) -> RenderNode {
        var node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

final class MonsterRenderer {
    static func makeNode(from model: MonsterModel) -> RenderNode {
        var node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

final class PlayerCastleRenderer {
    static func makeNode(from model: LevelCastleModel) -> RenderNode {
        var node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

final class EnemyCastleRenderer {
    static func makeNode(from model: LevelCastleModel) -> RenderNode {
        var node = RendererAdapter.makeNode(from: model)
        node.physicsBody = PhysicsAdapter.makeBody(from: model)
        node.userData = ["entityId": model.id]
        return node
    }
}

class LevelScene: SKScene {
    var gameLogicDelegate: LevelLogicDelegate
    var entities: [LevelEntity] = []
    var tasks: [Task] = []
    var frameCounter = 0
    var grid: Grid
    var monsterModels: [UUID: MonsterModel] = [:]
    var monsterNodes: [UUID: RenderNode] = [:]
    var heroModels: [UUID: HeroModel] = [:]
    var heroNodes: [UUID: RenderNode] = [:]
    var castleModels: [UUID: LevelCastleModel] = [:]
    var castleNodes: [UUID: RenderNode] = [:]

    init(gameLogicDelegate: LevelLogicDelegate,
         grid: Grid,
         background: SKColor = .gray) {
        self.gameLogicDelegate = gameLogicDelegate
        self.entities = []
        self.grid = grid
        super.init(size: CGSize(width: grid.width, height: grid.height))
        self.backgroundColor = background
        self.scaleMode = .aspectFit

        physicsWorld.contactDelegate = self
        initialiseEntities()
        LevelModelRegistry.shared.gameLogicDelegate = gameLogicDelegate

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
        guard let logic = gameLogicDelegate as? LevelLogic else {
            return
        }

        if logic.monsterCastleHealth <= 0 {
            showEndLevelLabel(text: "You Win 🎉")
            isPaused = true
            return
        }

        if logic.playerCastleHealth <= 0 {
            showEndLevelLabel(text: "You Lose 💀")
            isPaused = true
            return
        }
    }

    private func showEndLevelLabel(text: String) {
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Avenir-Heavy"
        label.position = CGPoint(x: grid.width / 2, y: grid.height / 2 + 50)
        label.name = "end_game_label"
        addChild(label)

        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontSize = 30
        restartLabel.fontColor = .yellow
        restartLabel.fontName = "Avenir"
        restartLabel.position = CGPoint(x: grid.width / 2, y: grid.height / 2 - 50)
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
                restartLevel()
            }
        }
    }

    private func restartLevel() {
        guard let view = self.view else {
            return
        }

        if let logic = gameLogicDelegate as? LevelLogic {
            logic.reset()
        }

        let newScene = LevelScene(gameLogicDelegate: gameLogicDelegate, grid: Grid())
        newScene.scaleMode = self.scaleMode
        view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }

    func spawnHero(type: HeroType, atX tileX: Int = 1, atY tileY: Int = 5) {
        assert(0 < tileX && tileX < grid.numCols - 1)
        assert(1 < tileY && tileY < grid.numLanes)
        guard let logic = gameLogicDelegate as? LevelLogic else {
            return
        }

        let size = grid.getNodeSize()
        let position = grid.adjustNodeOrigin(
            size: size, position: grid.getPosition(tileX: tileX, tileY: tileY)
        )

        let stats = EntityFactory.getHeroStats(type: type)

        guard logic.mana >= stats.manaCost else {
            print("❌ Not enough mana to spawn \(type)")
            return
        }

        logic.decreaseMana(by: stats.manaCost)

        var (model, node) = EntityFactory.makeHero(type: type, position: position, size: size)
        node.name = "hero"

        guard let skNode = node.asSKNode else {
            print("❌ Failed to cast RenderNode to SKNode for monster \(model.id)")
            return
        }

        heroModels[model.id] = model
        heroNodes[model.id] = node
        LevelModelRegistry.shared.setHeroModel(id: model.id, model: model)
        LevelModelRegistry.shared.setHeroNode(id: model.id, node: node)
        addChild(skNode)
    }

    private func spawnMonster(atX tileX: Int = 8, atY tileY: Int = 5) {
        assert(0 < tileX && tileX < grid.numCols - 1)
        assert(1 < tileY && tileY < grid.numLanes)

        let size = grid.getNodeSize()
        let position = grid.adjustNodeOrigin(
            size: size, position: grid.getPosition(tileX: tileX, tileY: tileY)
        )

        var (model, node) = EntityFactory.makeMonster(position: position, size: size)
        node.name = "monster"

        guard let skNode = node.asSKNode else {
            print("❌ Failed to cast RenderNode to SKNode for monster \(model.id)")
            return
        }

        monsterModels[model.id] = model
        monsterNodes[model.id] = node
        LevelModelRegistry.shared.setMonsterModel(id: model.id, model: model)
        LevelModelRegistry.shared.setMonsterNode(id: model.id, node: node)
        addChild(skNode)
    }

    private func spawnPlayerCastle() {
        let size = grid.getNodeSize(numTileY: 5)
        let position = grid.adjustNodeOrigin(
            size: size, position: grid.getPosition(tileX: 0, tileY: 2)
        )

        let (model, node) = EntityFactory.makeCastle(position: position, size: size, isPlayer: true)
        guard let skNode = node.asSKNode else {
            print("❌ Failed to cast RenderNode to SKNode for monster \(model.id)")
            return
        }
        castleModels[model.id] = model
        castleNodes[model.id] = node
        addChild(skNode)
    }

    private func spawnEnemyCastle() {
        let size = grid.getNodeSize(numTileY: 5)
        let position = grid.adjustNodeOrigin(
            size: size, position: grid.getPosition(tileX: grid.numCols - 1, tileY: 2)
        )

        let (model, node) = EntityFactory.makeCastle(position: position, size: size, isPlayer: false)
        guard let skNode = node.asSKNode else {
            print("❌ Failed to cast RenderNode to SKNode for monster \(model.id)")
            return
        }
        castleModels[model.id] = model
        castleNodes[model.id] = node
        addChild(skNode)
    }

    private func spawnTask() {
        let texture = SKTexture(imageNamed: "task")

        let size = grid.getNodeSize()
        let position = grid.adjustNodeOrigin(
            size: size, position: grid.getPosition(tileX: grid.numCols - 1, tileY: 1)
        )

        let task = Task(texture: texture, size: size)
        task.position = position

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
        spawnHero(type: .swordsman, atX: 3)
    }
}

extension LevelScene {
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

            // Range Attack logic (optional)
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
