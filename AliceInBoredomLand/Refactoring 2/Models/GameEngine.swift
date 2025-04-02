//
//  GameEngine.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

class GameEngine {
    var gameLogicDelegate: GameLogicDelegate
    var grid: Grid
    var entities: [GameEntity] = []
    var tasks: [Task] = []
    var isPaused: Bool = false

    var frameCounter = 0
    var physicsEngine: PhysicsEngine
    var hitboxGameEntitySynchronizer: ArraySynchronizer<PhysicsEntity, GameEntity> = ArraySynchronizer()

    init(gameLogicDelegate: GameLogicDelegate, grid: Grid) {
        self.gameLogicDelegate = gameLogicDelegate
        self.grid = grid
        physicsEngine = PhysicsEngineImpl(boundarySize: CGSize(width: GameEngine.height, height: GameEngine.width))
    }

    // Todo: Rework in a format that allows for actually using currentTime, instead of assuming even time steps
    func update(_ currentTime: TimeInterval) {
        frameCounter += 1

        if frameCounter.isMultiple(of: 30) {
            performFrameLogic(currentTime)
        }

        updateProjectiles()
    }

    private func performFrameLogic(_ currentTime: TimeInterval) {
        let frameIndex = frameCounter / 30

        // pending rework: need to find a way to sync physics updates into objects properly
        // also need to figure out whether GameEntity should have a update function
        // since we'd need to capture the physicsengine as well?
        if frameIndex % 2 == 1 {
            entities.compactMap { $0 as? Hero }.forEach { $0.update(dt: currentTime) }
        } else {
            entities.compactMap { $0 as? Monster }.forEach { $0.update(dt: currentTime) }
        }

        // tasks.forEach { $0.update(dt: currentTime) }
        // Fix collision handling on the game layer later
        let physicsEvents = physicsEngine.update(dt: currentTime)
        handleEvents(events: physicsEvents)

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

        let typeLowercased = type.lowercased()
        let size = grid.getNodeSize()
        let position = grid.adjustEntityOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: tileY))

        let hero: Hero = {
            switch typeLowercased {
            // case "archer":
                // return Archer(texture: texture, size: size)
            case "tank":
                return Tank(posX: position.x, posY: position.y, size: size)
            case "swordsman":
                return Swordsman(posX: position.x, posY: position.y, size: size)
            default:
                return Swordsman(posX: position.x, posY: position.y, size: size)
            }
        }()

        guard gameLogicDelegate.mana >= 15 else { // replace with factory function later, this is incorrect behaviour
            print("Not enough mana to spawn \(typeLowercased)")
            return
        }

        gameLogicDelegate.decreaseMana(by: 15)

        physicsEngine.addEntity(hero.physicsEntity)
        hitboxGameEntitySynchronizer.add(innerElement: hero.physicsEntity, outerElement: hero)
        entities.append(hero)
    }

    private func spawnMonster(atX tileX: Int = 8, atY tileY: Int = 5) {
        assert(0 < tileX && tileX < GameEngine.numCols - 1)
        assert(1 < tileY && tileY < GameEngine.numRows)

        let size = grid.getNodeSize()
        let position = grid.adjustEntityOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: tileY))
        let monster = Monster(health: 80, attack: 40, speed: 20, posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(monster.physicsEntity)
        hitboxGameEntitySynchronizer.add(innerElement: monster.physicsEntity, outerElement: monster)
        entities.append(monster)
    }

    private func spawnPlayerCastle() {
        let size = grid.getNodeSize(numTileY: 5)
        let position = grid.adjustEntityOrigin(size: size, position: grid.getPosition(tileX: 0, tileY: 2))
        let playerCastle = GameCastle(isPlayer: true, posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(playerCastle.physicsEntity)
        hitboxGameEntitySynchronizer.add(innerElement: playerCastle.physicsEntity, outerElement: playerCastle)
        entities.append(playerCastle)
    }

    private func spawnEnemyCastle() {
        let size = grid.getNodeSize(numTileY: 5)
        let position = grid.adjustEntityOrigin(size: size,
                                               position: grid.getPosition(tileX: GameEngine.numCols - 1, tileY: 2))
        let enemyCastle = GameCastle(isPlayer: false, posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(enemyCastle.physicsEntity)
        hitboxGameEntitySynchronizer.add(innerElement: enemyCastle.physicsEntity, outerElement: enemyCastle)
        entities.append(enemyCastle)
    }

    private func spawnTask() {
        let size = grid.getNodeSize()
        let position = grid.adjustEntityOrigin(size: size,
                                               position: grid.getPosition(tileX: GameEngine.numCols - 1, tileY: 1))
        // Pending task reformatting
        let task = Task(posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(task.physicsEntity)
        tasks.append(task)
    }

    private func removeDeadEntities() {
        entities = entities.filter { entity in
            if !entity.isAlive {
                physicsEngine.removeEntity(entity.physicsEntity)
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
            let distance = (monster.posX - archerPosition.x)
            if distance <= range {
                return true
            }
        }
        return false
    }
}
