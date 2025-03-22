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

    let tileSize = CGSize(width: height / Double(numRows), height: width / Double(numCols))

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

    override func update(_ currentTime: TimeInterval) { // TimeInterval is in seconds
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
    }

    // Note: Coordinate system has the origin be at the bottom-left as far as I can tell
    // SpritKitNodes have their origin at the center though
    private func spawnHero(atX tileX: Int, atY tileY: Int = 5, type: String = "hero") {
        let texture = SKTexture(imageNamed: type)

        let hero: Hero
        if type == "archer" {
            hero = Archer(texture: texture, size: tileSize, health: 80, attack: 20, speed: 5, manaCost: 15)
        } else {
            hero = Hero(texture: texture, size: tileSize, health: 100, attack: 1, speed: 30, manaCost: 10)
        }

        // SKSpriteNode has origin at center
        hero.position = CGPoint(x: (CGFloat(tileX) + 1 / 2) * tileSize.width,
                                y: (CGFloat(tileY) + 1 / 2) * tileSize.height)

        hero.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BitMask.Hero.archer

        addChild(hero)
        entities.append(hero)
    }

    private func spawnMonster(atX tileX: Int, atY tileY: Int = 5) {
        let texture = SKTexture(imageNamed: "monster")
        let monster = Monster(texture: texture, size: tileSize, health: 100, attack: 20, speed: 30.0)

        monster.position = CGPoint(x: (CGFloat(tileX) + 1 / 2) * tileSize.width,
                                   y: (CGFloat(tileY) + 1 / 2) * tileSize.height)

        monster.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = BitMask.Monster.titan
        monster.physicsBody?.contactTestBitMask = BitMask.Hero.archer | BitMask.Hero.swordsman | BitMask.Hero.tanker

        addChild(monster)
        entities.append(monster)
    }

    private func spawnPlayerCastle() {
        let texture = SKTexture(imageNamed: "player-castle")
        let size = CGSize(width: tileSize.width, height: tileSize.height * 5)
        let playerCastle = GameCastle(texture: texture, size: size, isPlayer: true)

        playerCastle.position = CGPoint(x: 1 / 2 * tileSize.width, y: 4.5 * tileSize.height)

        playerCastle.physicsBody = SKPhysicsBody(rectangleOf: size)
        playerCastle.physicsBody?.affectedByGravity = false
        playerCastle.physicsBody?.isDynamic = false

        addChild(playerCastle)
        entities.append(playerCastle)
    }

    private func spawnEnemyCastle() {
        let texture = SKTexture(imageNamed: "enemy-castle")
        let size = CGSize(width: tileSize.width, height: tileSize.height * 5)
        let enemyCastle = GameCastle(texture: texture, size: size, isPlayer: false)

        enemyCastle.position = CGPoint(x: (CGFloat(GameScene.numCols) - 1 / 2) * tileSize.width,
                                       y: 4.5 * tileSize.height)

        enemyCastle.physicsBody = SKPhysicsBody(rectangleOf: size)
        enemyCastle.physicsBody?.affectedByGravity = false
        enemyCastle.physicsBody?.isDynamic = false

        addChild(enemyCastle)
        entities.append(enemyCastle)
    }

    private func spawnTask() {
        let texture = SKTexture(imageNamed: "task")
        let task = Task(texture: texture, size: tileSize)

        task.position = CGPoint(x: (CGFloat(GameScene.numCols) - 1 / 2) * tileSize.width, y: 1.5 * tileSize.height)

        task.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
        task.physicsBody?.affectedByGravity = false
        task.physicsBody?.isDynamic = true
        task.physicsBody?.categoryBitMask = BitMask.Task.task
        task.physicsBody?.contactTestBitMask = BitMask.Task.task

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
        spawnHero(atX: 1, type: "archer")
        spawnHero(atX: 2, atY: 3)
        spawnMonster(atX: 8)
        spawnMonster(atX: 8, atY: 3)
        spawnMonster(atX: 8, atY: 2)
    }

    private func handleCollisions() {
        print("colliding")
    }

    override func didMove(to view: SKView) {
        initialiseEntities()
        physicsWorld.contactDelegate = self
    }
}
