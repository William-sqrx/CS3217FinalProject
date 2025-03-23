//
//  GameScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

class GameScene: SKScene {
    var gameLogicDelegate: GameLogicDelegate
    var entities: [GameEntity] = []
    var tasks: [Task] = []
    var frameCounter = 0

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

    override func update(_ currentTime: TimeInterval) {
        // For now, ignoring the possibility of variable time steps to make alternate processing easier
        frameCounter += 1
        if frameCounter.isMultiple(of: 30) {
            let deltaTime: TimeInterval = 1.0

            if (frameCounter / 30) % 2 == 1 {
                entities.filter { $0 is Hero }.forEach { $0.update(deltaTime: deltaTime) }
            } else {
                entities.filter { $0 is Monster }.forEach { $0.update(deltaTime: deltaTime) }
            }
            tasks.forEach { $0.update(deltaTime: deltaTime) }

            if (frameCounter / 30) % 8 == 1 {
                spawnTask()
            }

            removeDeadEntities()
        }

        entities.compactMap { $0 as? Arrow }.forEach { arrow in
            arrow.updateArrow(deltaTime: 1.0)
        }
    }

    // Note: Coordinate system has the origin be at the bottom-left as far as I can tell
    // SpritKitNodes have their origin at the center though
    func spawnHero(atX tileX: Int, atY tileY: Int = 5, type: String = "hero") {
        assert(0 < tileX && tileX < GameScene.numCols - 1)
        assert(1 < tileY && tileY < GameScene.numRows)

        let texture = SKTexture(imageNamed: type)
        let size = getNodeSize()

        let hero: Hero

        switch type {
        case "archer":
            hero = Archer(texture: texture, size: size, health: 80, attack: 1, speed: 25, manaCost: 15)
        case "tank":
            hero = Tank(texture: texture, size: size)
        case "swordsman":
            hero = Swordsman(texture: texture, size: size)
        default:
            hero = Hero(texture: texture, size: size, health: 100, attack: 1, speed: 30, manaCost: 10)
        }

        // SKSpriteNode has origin at center
        hero.position = adjustNodeOrigin(node: hero, position: getPosition(tileX: tileX, tileY: tileY))

        hero.physicsBody = SKPhysicsBody(rectangleOf: size)
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BitMask.Hero.archer

        addChild(hero)
        entities.append(hero)
    }

    private func spawnMonster(atX tileX: Int, atY tileY: Int = 5) {
        assert(0 < tileX && tileX < GameScene.numCols - 1)
        assert(1 < tileY && tileY < GameScene.numRows)

        let texture = SKTexture(imageNamed: "monster")
        let size = getNodeSize()
        let monster = Monster(texture: texture, size: size, health: 100, attack: 20, speed: 40.0)

        monster.position = adjustNodeOrigin(node: monster, position: getPosition(tileX: tileX, tileY: tileY))

        monster.physicsBody = SKPhysicsBody(rectangleOf: size)
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = BitMask.Monster.titan
        monster.physicsBody?.contactTestBitMask = BitMask.Hero.archer | BitMask.Hero.swordsman | BitMask.Hero.tanker

        addChild(monster)
        entities.append(monster)
    }

    private func spawnPlayerCastle() {
        let texture = SKTexture(imageNamed: "player-castle")
        let size = getNodeSize(numTileY: 5)
        let playerCastle = GameCastle(texture: texture, size: size, isPlayer: true)

        playerCastle.position = adjustNodeOrigin(node: playerCastle, position: getPosition(tileX: 0, tileY: 2))

        playerCastle.physicsBody = SKPhysicsBody(rectangleOf: size)
        playerCastle.physicsBody?.affectedByGravity = false
        playerCastle.physicsBody?.isDynamic = false

        addChild(playerCastle)
        entities.append(playerCastle)
    }

    private func spawnEnemyCastle() {
        let texture = SKTexture(imageNamed: "enemy-castle")
        let size = getNodeSize(numTileY: 5)
        let enemyCastle = GameCastle(texture: texture, size: size, isPlayer: false)

        enemyCastle.position = adjustNodeOrigin(node: enemyCastle,
                                                position: getPosition(tileX: GameScene.numCols - 1, tileY: 2))

        enemyCastle.physicsBody = SKPhysicsBody(rectangleOf: size)
        enemyCastle.physicsBody?.affectedByGravity = false
        enemyCastle.physicsBody?.isDynamic = false

        addChild(enemyCastle)
        entities.append(enemyCastle)
    }

    private func spawnTask() {
        let texture = SKTexture(imageNamed: "task")
        let size = getNodeSize()
        let task = Task(texture: texture, size: size)

        task.position = adjustNodeOrigin(node: task,
                                         position: getPosition(tileX: GameScene.numCols - 1, tileY: 1))

        task.physicsBody = SKPhysicsBody(rectangleOf: size)
        task.physicsBody?.affectedByGravity = false
        task.physicsBody?.isDynamic = true
        task.physicsBody?.categoryBitMask = BitMask.Task.task
        task.physicsBody?.contactTestBitMask = BitMask.Task.task

        addChild(task)
        tasks.append(task)
    }

    private func removeDeadEntities() {
        print(entities.count)
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
        spawnHero(atX: 1, type: "archer")
        spawnHero(atX: 1, atY: 3)
        spawnHero(atX: 1, atY: 2, type: "tank")
        spawnMonster(atX: 8, atY: 3)
    }

    private func handleCollisions() {
        print("colliding")
    }

    override func didMove(to view: SKView) {
        initialiseEntities()
        physicsWorld.contactDelegate = self
    }
}

extension GameScene {
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
