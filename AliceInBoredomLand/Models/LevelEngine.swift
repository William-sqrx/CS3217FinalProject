//
//  LevelEngine.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

class LevelEngine: LevelEngineFacade {
    var levelLogicDelegate: LevelLogicFacade
    var grid: Grid
    var entities: [LevelEntity] = []
    var tasks: [Task] = []
    var isPaused: Bool = false
    var isWin: Bool {
        levelLogicDelegate.isWin
    }
    var isLose: Bool {
        levelLogicDelegate.isLose
    }

    var frameCounter = 0
    var physicsEngine: PhysicsEngine
    var hitboxLevelEntitySynchronizer: ArraySynchronizer<PhysicsEntity, LevelEntity> = ArraySynchronizer()

    init(levelLogicDelegate: LevelLogicFacade, grid: Grid) {
        self.levelLogicDelegate = levelLogicDelegate
        self.grid = grid
        physicsEngine = PhysicsEngine(boundarySize: CGSize(width: grid.height, height: grid.width))

        initialiseEntities()
    }

    // Todo: Rework in a format that allows for actually using currentTime, instead of assuming even time steps
    func update(_ currentTime: TimeInterval) {
        frameCounter += 1

        if true || frameCounter.isMultiple(of: 30) {
            performFrameLogic(currentTime)
        }

        updateProjectiles()
    }

    private func performFrameLogic(_ currentTime: TimeInterval) {
        let frameIndex = frameCounter / 30

        // pending rework: need to find a way to sync physics updates into objects properly
        // also need to figure out whether LevelEntity should have a update function
        // since we'd need to capture the physicsengine as well?
        if frameIndex % 2 == 1 {
            entities.compactMap { $0 as? Hero }.forEach {
                let oldEntity = $0.physicsEntity
                $0.update(dt: currentTime)
                physicsEngine.replaceEntity(oldEntity, with: $0.physicsEntity)
            }
        } else {
            entities.compactMap { $0 as? Monster }.forEach {
                let oldEntity = $0.physicsEntity
                $0.update(dt: currentTime)
                physicsEngine.replaceEntity(oldEntity, with: $0.physicsEntity)
            }
        }

        tasks.forEach {
            let oldEntity = $0.physicsEntity
            $0.update(dt: currentTime)
            physicsEngine.replaceEntity(oldEntity, with: $0.physicsEntity)
        }

        let physicsEvents = physicsEngine.update(dt: currentTime)

        for var entity in entities {
            for physicsBody in physicsEngine.physicsBodies where physicsBody == entity.physicsEntity {
                entity.physicsEntity = physicsBody
            }
        }

        for task in tasks {
            for physicsBody in physicsEngine.physicsBodies where physicsBody == task.physicsEntity {
                task.physicsEntity = physicsBody
            }
        }

        hitboxLevelEntitySynchronizer.clearAll()
        for entity in entities {
            hitboxLevelEntitySynchronizer.add(innerElement: entity.physicsEntity, outerElement: entity)
        }

        if !physicsEvents.isEmpty {
            // print(physicsEvents)
        }
        handleEvents(events: physicsEvents)

        entities = hitboxLevelEntitySynchronizer.getOuterArray()
        physicsEngine.clearAll()
        for entity in hitboxLevelEntitySynchronizer.getInnerArray() {
            physicsEngine.addEntity(entity)
        }
        for task in tasks {
            physicsEngine.addEntity(task.physicsEntity)
        }

        print(tasks.count)
        if tasks.count < 3 && frameCounter % 30 == 1 {
            spawnTask()
        }
        removeDeadEntities()

    }

    private func updateProjectiles() {
        entities.compactMap { $0 as? PendingArrow }.forEach { $0.updateArrow(deltaTime: 1.0) }
    }

    func spawnHero(atY tileY: Int = 5, type: String = "hero") {
        assert(1 < tileY && tileY < grid.numLanes)

        let typeLowercased = type.lowercased()
        let tileX = 1
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

        guard levelLogicDelegate.mana >= 15 else { // replace with factory function later, this is incorrect behaviour
            print("Not enough mana to spawn \(typeLowercased)")
            return
        }

        levelLogicDelegate.decreaseMana(by: 15)

        physicsEngine.addEntity(hero.physicsEntity)
        hitboxLevelEntitySynchronizer.add(innerElement: hero.physicsEntity, outerElement: hero)
        entities.append(hero)
    }

    func spawnMonster(atY tileY: Int = 5) {
        assert(1 < tileY && tileY < grid.numLanes)

        let tileX = 2
        let size = grid.getNodeSize()
        let position = grid.adjustEntityOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: tileY))
        let monster = Monster(health: 80, attack: 40, speed: 20, posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(monster.physicsEntity)
        hitboxLevelEntitySynchronizer.add(innerElement: monster.physicsEntity, outerElement: monster)
        entities.append(monster)
    }

    private func spawnPlayerCastle() {
        let size = grid.getNodeSize(numTileY: 5)
        let position = grid.adjustEntityOrigin(size: size, position: grid.getPosition(tileX: 0, tileY: 2))
        let playerCastle = Castle(isPlayer: true, posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(playerCastle.physicsEntity)
        hitboxLevelEntitySynchronizer.add(innerElement: playerCastle.physicsEntity, outerElement: playerCastle)
        entities.append(playerCastle)
    }

    private func spawnEnemyCastle() {
        let size = grid.getNodeSize(numTileY: 5)
        let position = grid.adjustEntityOrigin(size: size,
                                               position: grid.getPosition(tileX: grid.numCols - 1, tileY: 2))
        let enemyCastle = Castle(isPlayer: false, posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(enemyCastle.physicsEntity)
        hitboxLevelEntitySynchronizer.add(innerElement: enemyCastle.physicsEntity, outerElement: enemyCastle)
        entities.append(enemyCastle)
    }

    private func spawnTask() {
        let size = grid.getNodeSize()
        let position = grid.adjustEntityOrigin(size: size,
                                               position: grid.getPosition(tileX: grid.numCols - 1, tileY: 1))
        // Pending task reformatting
        let task = Task(posX: position.x, posY: position.y, size: size)

        physicsEngine.addEntity(task.physicsEntity)
        tasks.append(task)
    }

    func restartLevel() {
        levelLogicDelegate.reset()
        entities.removeAll()
        hitboxLevelEntitySynchronizer.clearAll()
        physicsEngine.clearAll()
        tasks.removeAll()

        frameCounter = 0
        initialiseEntities()
    }

    private func removeDeadEntities() {
        entities = entities.filter { entity in
            if !entity.isAlive {
                physicsEngine.removeEntity(entity.physicsEntity)
                hitboxLevelEntitySynchronizer.removeInnerElement(entity.physicsEntity)
                return false
            }
            return true
        }
        tasks = tasks.filter { task in
            if task.availableFrames <= 0 {
                physicsEngine.removeEntity(task.physicsEntity)
                return false
            }
            return true
        }
    }

    func removeTask(_ task: Task) {
        tasks.removeAll { $0.physicsEntity == task.physicsEntity }
    }

    func initialiseEntities() {
        spawnPlayerCastle()
        spawnEnemyCastle()
        spawnMonster()

        spawnHero(type: "tank")
    }
}

extension LevelEngine {
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
