//
//  GameEngine.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

class GameEngine {
    var gameLogicDelegate: GameLogicDelegate
    var entities: [GameEntity] = []
    var tasks: [Task] = []
    var frameCounter = 0

    var physicsEngine: PhysicsEngine
    var isPaused: Bool = false

    // Please use getNodeSize instead of this directly
    let tileSize = CGSize(width: width / Double(numCols),
                          height: (height - rowSpacing * Double(numRows - 1)) / Double(numRows))

    init() {
        physicsEngine = PhysicsEngineImpl(boundarySize: CGSize(width: GameEngine.height, height: GameEngine.width))
    }

    // Todo: Rework in a format that allows for actually using currentTime, instead of assuming even time steps
    func update(_ currentTime: TimeInterval) {
        frameCounter += 1

        if frameCounter.isMultiple(of: 30) {
            performFrameLogic()
        }

        updateProjectiles()
    }

    private func performFrameLogic() {
        let deltaTime: TimeInterval = 1.0
        let frameIndex = frameCounter / 30

        // pending rework: need to find a way to sync physics updates into objects properly
        // also need to figure out whether GameEntity should have a update function, since we'd need to capture the physicsengine as well?
        if frameIndex % 2 == 1 {
            entities.compactMap { $0 as? Hero }.forEach { $0.update(deltaTime: deltaTime) }
        } else {
            entities.compactMap { $0 as? Monster }.forEach { $0.update(deltaTime: deltaTime) }
        }

        tasks.forEach { $0.update(deltaTime: deltaTime) }

        if frameIndex % 6 == 1 {
            spawnTask()
        }
        removeDeadEntities()
    }

    private func updateProjectiles() {
        entities.compactMap { $0 as? Arrow }.forEach { $0.updateArrow(deltaTime: 1.0) }
    }

    func spawnHero(atX tileX: Int = 1, atY tileY: Int = 5, type: String = "hero") {
        assert(0 < tileX && tileX < GameEngine.numCols - 1)
        assert(1 < tileY && tileY < GameEngine.numRows)

        guard let logic = gameLogicDelegate as? GameLogic else {
            return
        }

        let typeLowercased = type.lowercased()
        let size = getNodeSize()
        let position = adjustEntityOrigin(size: size, position: getPosition(tileX: tileX, tileY: tileY))

        let hero: Hero = {
            switch typeLowercased {
            case "archer":
                // return Archer(texture: texture, size: size)
            case "tank":
                return Tank(posX: position.x, posY: position.y, size: size)
            case "swordsman":
                return Swordsman(posX: position.x, posY: position.y, size: size)
            default:
                return Swordsman(posX: position.x, posY: position.y, size: size)
            }
        }()

        guard logic.mana >= 15 else { // replace with factory function later, this is incorrect behaviour
            print("Not enough mana to spawn \(typeLowercased)")
            return
        }

        logic.decreaseMana(by: 15)

        addChild(hero)
        entities.append(hero)
    }

    private func spawnMonster(atX tileX: Int = 8, atY tileY: Int = 5) {
        assert(0 < tileX && tileX < GameEngine.numCols - 1)
        assert(1 < tileY && tileY < GameEngine.numRows)

        let size = getNodeSize()
        let position = adjustEntityOrigin(size: size, position: getPosition(tileX: tileX, tileY: tileY))
        let monster = Monster(health: 80, attack: 40, speed: 20, posX: position.x, posY: position.y, size: size)

        addChild(monster)
        entities.append(monster)
    }

    private func spawnPlayerCastle() {
        let size = getNodeSize(numTileY: 5)
        let position = adjustEntityOrigin(size: size, position: getPosition(tileX: 0, tileY: 2))
        let playerCastle = GameCastle(isPlayer: true, posX: position.x, posY: position.y, size: size)


        addChild(playerCastle)
        entities.append(playerCastle)
    }

    private func spawnEnemyCastle() {
        let size = getNodeSize(numTileY: 5)
        let position = adjustEntityOrigin(size: size, position: getPosition(tileX: GameEngine.numCols - 1, tileY: 2))
        let enemyCastle = GameCastle(isPlayer: false, posX: position.x, posY: position.y, size: size)

        addChild(enemyCastle)
        entities.append(enemyCastle)
    }

    private func spawnTask() {
        let size = getNodeSize()
        let position = adjustEntityOrigin(size: size, position: getPosition(tileX: GameEngine.numCols - 1, tileY: 1))
        // Pending task reformatting
        let task = Task(texture: texture, size: size)

        addChild(task)
        tasks.append(task)
    }

    private func removeDeadEntities() {
        entities = entities.filter { entity in
            if !entity.isAlive {
                // Pending modification
                entity.node.removeFromParent()
                return false
            }
            return true
        }
    }

    func initialiseEntities() {
        spawnPlayerCastle()
        spawnEnemyCastle()
        spawnMonster(atX: 3)
    }
}

extension GameEngine {
    func isMonsterInRange(_ archerPosition: CGPoint, range: CGFloat) -> Bool {
        let monsters = entities.compactMap { $0 as? Monster }

        for monster in monsters {
            let distance = (monster.position - archerPosition).length()
            if distance <= range {
                return true
            }
        }
        return false
    }
}

