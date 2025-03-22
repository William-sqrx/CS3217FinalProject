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

    // Note: Coordinate system has the origin be at the bottom-left as far as I cn tell
    private func spawnHero(at tileX: Int, type: String = "hero") {
        let texture = SKTexture(imageNamed: type)
        let size = CGSize(width: tileSize, height: tileSize)

        let hero: Hero
        if type == "archer" {
            hero = Archer(texture: texture, size: size, health: 80, attack: 20, speed: 5, manaCost: 15)
        } else {
            hero = Hero(texture: texture, size: size, health: 100, attack: 1, speed: 30, manaCost: 10)
        }

        hero.position = CGPoint(x: CGFloat(tileX) * tileSize, y: GameScene.height / 2)

        hero.physicsBody = SKPhysicsBody(rectangleOf: size)
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BitMask.Hero.archer

        addChild(hero)
        entities.append(hero)
    }

    private func spawnMonster(at tileX: Int) {
        let texture = SKTexture(imageNamed: "monster")
        let size = CGSize(width: tileSize, height: tileSize)
        let monster = Monster(texture: texture, size: size, health: 100, attack: 10, speed: 30.0)

        monster.position = CGPoint(x: CGFloat(tileX) * tileSize, y: GameScene.height / 2)

        monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize, height: tileSize))
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = BitMask.Monster.titan
        monster.physicsBody?.contactTestBitMask = BitMask.Hero.archer | BitMask.Hero.swordsman | BitMask.Hero.tanker

        addChild(monster)
        entities.append(monster)
    }

    private func spawnTask() {
        let texture = SKTexture(imageNamed: "task")
        let size = CGSize(width: tileSize, height: tileSize)
        let task = Task(texture: texture, size: size)

        task.position = CGPoint(x: CGFloat(8) * tileSize, y: tileSize / 2)

        task.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize, height: tileSize))
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

    func initiateEntities() {
        spawnHero(at: 1, type: "archer")
        // spawnHero(at: 1)
        spawnMonster(at: 5)
    }

    private func handleCollisions() {
        print("colliding")
    }

    override func didMove(to view: SKView) {
        initiateEntities()
        physicsWorld.contactDelegate = self
    }
}
