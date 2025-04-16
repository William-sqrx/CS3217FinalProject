//
//  LevelScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

class LevelScene: SKScene, SKPhysicsContactDelegate {
    var entities: [GameEntity] = []
    var gameLogicDelegate: LevelLogicDelegate
    var frameCounter = 0
    var grid: Grid
    let factory = EntityFactory()

    init(gameLogicDelegate: LevelLogicDelegate, grid: Grid) {
        self.gameLogicDelegate = gameLogicDelegate
        self.grid = grid
        super.init(size: CGSize(width: grid.width, height: grid.height))
        self.backgroundColor = .gray
        self.scaleMode = .aspectFit
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        spawnInitialEntities()
    }

    func spawnInitialEntities() {
        spawnCastle(isPlayer: true)
        spawnCastle(isPlayer: false)
        spawnMonster()
        spawnHero(type: "swordsman")
    }

    func spawnHero(type: String, tileY: Int = 5) {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: 1, tileY: tileY))

        guard let hero = factory.makeHero(type: type, position: pos, size: size),
              let logic = gameLogicDelegate as? LevelLogic,
              logic.mana >= hero.manaCost else {
            print("❌ Not enough mana or invalid hero type")
            return
        }

        logic.decreaseMana(by: hero.manaCost)
        addChild(hero)
        entities.append(hero)
    }

    func spawnMonster() {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: 8, tileY: 5))
        let monster = factory.makeMonster(position: pos, size: size)
        addChild(monster)
        entities.append(monster)
    }

    func spawnCastle(isPlayer: Bool) {
        let size = grid.getNodeSize(numTileY: 5)
        let tileX = isPlayer ? 0 : (grid.numCols - 1)
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: 2))
        let castle = factory.makeCastle(position: pos, size: size, isPlayer: isPlayer)
        addChild(castle)
        entities.append(castle)
    }

    override func update(_ currentTime: TimeInterval) {
        frameCounter += 1
        if frameCounter.isMultiple(of: 30) {
            performFrameLogic(currentTime: currentTime)
        }
    }

    private func performFrameLogic(currentTime: TimeInterval) {
        let deltaTime: TimeInterval = 1.0
        if frameCounter.isMultiple(of: 180) {
            spawnTask()
        }

        for entity in entities {
            entity.update(deltaTime: deltaTime)
            if let hero = entity as? Hero, hero.shouldAttack(currentTime: currentTime) {
                // Add arrow logic later
                hero.lastAttackTime = currentTime
            }
        }

        removeDeadEntities()
        checkWinLose()
    }

    func spawnTask() {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: grid.numCols - 1, tileY: 1))
        let task = Task(position: pos, size: size)
        addChild(task)
        entities.append(task)
    }

    private func removeDeadEntities() {
        entities.removeAll { entity in
            if entity.health <= 0 {
                entity.removeFromParent()
                return true
            }
            return false
        }
    }

    private func checkWinLose() {
        guard let logic = gameLogicDelegate as? LevelLogic else {
            return
        }

        if logic.monsterCastleHealth <= 0 {
            endLevel(text: "You Win 🎉")
        } else if logic.playerCastleHealth <= 0 {
            endLevel(text: "You Lose 💀")
        }
    }

    private func endLevel(text: String) {
        isPaused = true
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Avenir-Heavy"
        label.position = CGPoint(x: grid.width / 2, y: grid.height / 2 + 50)
        addChild(label)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard
            let nodeA = contact.bodyA.node as? GameEntity,
            let nodeB = contact.bodyB.node as? GameEntity
        else { return }

        let names = [nodeA.name, nodeB.name]

        // 🧟 Monster hits player castle
        if names.contains("monster") && names.contains("player-castle") {
            print("✅ Monster collided with player castle")
            if let castle = [nodeA, nodeB].first(where: { $0.name == "player-castle" }) {
                ActionPerformer.perform(DamageAction(amount: 1_000), on: castle)
                if let logic = gameLogicDelegate as? LevelLogic {
                    logic.playerCastleHealth -= 1_000
                }
            }
        }

        // 🛡️ Hero hits monster castle
        if names.contains("hero") && names.contains("monster-castle") {
            print("✅ Hero collided with monster castle")
            if let castle = [nodeA, nodeB].first(where: { $0.name == "monster-castle" }) {
                ActionPerformer.perform(DamageAction(amount: 10), on: castle)
                if let logic = gameLogicDelegate as? LevelLogic {
                    logic.monsterCastleHealth -= 10
                }
            }
        }

        // ⚔️ Monster collides with hero
        if let monster = [nodeA, nodeB].first(where: { $0.name == "monster" }) as? GameEntity,
           let hero = [nodeA, nodeB].first(where: { $0.name == "hero" }) as? GameEntity {
            print("✅ Monster collided with hero")
            ActionPerformer.perform(KnockbackAction(direction: CGVector(dx: 1, dy: 0), duration: 0.2, speed: 30),
                                    on: monster)
            ActionPerformer.perform(KnockbackAction(direction: CGVector(dx: -1, dy: 0), duration: 0.2, speed: 30),
                                    on: hero)

            ActionPerformer.perform(DamageAction(amount: monster.attack), on: hero)
            ActionPerformer.perform(DamageAction(amount: hero.attack), on: monster)
        }
    }
}

// MARK: - Supporting Types

struct Grid {
    let width: Double
    let height: Double
    let numCols: Int
    let numLanes: Int
    let laneSpacing: Double
    let tileSize: CGSize

    func getPosition(tileX: Int, tileY: Int) -> CGSize {
        CGSize(width: Double(tileX) * tileSize.width,
               height: Double(tileY) * tileSize.height + max(Double(tileY - 1), 0) * laneSpacing)
    }

    func getNodeSize(numTileX: Int = 1, numTileY: Int = 1) -> CGSize {
        CGSize(width: Double(numTileX) * tileSize.width,
               height: Double(numTileY) * tileSize.height + Double(numTileY - 1) * laneSpacing)
    }

    func adjustNodeOrigin(size: CGSize, position: CGSize) -> CGPoint {
        CGPoint(x: position.width + size.width / 2, y: position.height + size.height / 2)
    }

    init(width: Double = 1_000, height: Double = 700, numCols: Int = 10, numLanes: Int = 7, laneSpacing: Double = 10) {
        self.width = width
        self.height = height
        self.numCols = numCols
        self.numLanes = numLanes
        self.laneSpacing = laneSpacing
        self.tileSize = CGSize(width: width / Double(numCols),
                               height: (height - laneSpacing * Double(numLanes - 1)) / Double(numLanes))
    }
}

protocol LevelLogicDelegate {
    var playerCastleHealth: Int { get }
    var monsterCastleHealth: Int { get }
    var timeLeft: Int { get }
    var isWin: Bool { get }
    func decreaseMana(by amount: Int)
    func reset()
}
