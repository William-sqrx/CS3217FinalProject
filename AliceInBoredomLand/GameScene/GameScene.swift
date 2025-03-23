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
    var frameCounter = 0

    init(gameLogicDelegate: GameLogicDelegate,
         background: SKColor = .black,
         size: CGSize = CGSize(width: GameScene.width, height: GameScene.height)) {
            self.gameLogicDelegate = gameLogicDelegate
            self.entities = []
            super.init(size: CGSize(width: GameScene.width, height: GameScene.height))
            self.backgroundColor = background
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

            removeDeadEntities()
        }
        
        entities.compactMap { $0 as? Arrow }.forEach { arrow in
            arrow.updateArrow(deltaTime: 1.0)
        }
    }

    func spawnHero(at tileX: Int, type: String = "hero") {
        let texture = SKTexture(imageNamed: type)
        let size = CGSize(width: tileSize, height: tileSize)

        let hero: Hero
        
        switch type {
        case "archer":
            hero = Archer(texture: texture, size: size, health: 80, attack: 1, speed: 5, manaCost: 15)
        case "tank":
            hero = Tank(texture: texture, size: size)
        case "swordsman":
            hero = Swordsman(texture: texture, size: size)
        default:
            hero = Hero(texture: texture, size: size, health: 100, attack: 1, speed: 30, manaCost: 10)
        }

        hero.position = CGPoint(x: CGFloat(tileX) * tileSize, y: GameScene.height / 2)
        print("spawning hero")
        print("at", CGFloat(tileX) * tileSize, GameScene.height / 2)

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

    func initiateEntities() {
//        spawnHero(at: 1, type: "archer")
        // spawnHero(at: 1)
        spawnMonster(at: 7)
    }

    private func handleCollisions() {
        print("colliding")
    }

    override func didMove(to view: SKView) {
        initiateEntities()
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
