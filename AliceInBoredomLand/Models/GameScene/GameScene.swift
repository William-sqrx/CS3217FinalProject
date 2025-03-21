//
//  GameScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

class GameScene: SKScene, Publisher {
    typealias V = [(UUID, UUID)]

    // One Extension: Standard gameplay loop stuff
    // Second Extension: Factory stuff
    // Third Extension: Collision Stuff?

    var gameLogicDelegate: GameLogicDelegate
    var entities: [GameEntity] = []
    var entityCollisions: [(UUID, UUID)] = []
    var collisionSubscribers: [any Subscriber<[(UUID, UUID)]>] = []
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

    override func update(_ currentTime: TimeInterval) { // TimeInterval is in seconds
        // For now, ignoring the possibility of variable time steps to make alternate processing easier
        frameCounter += 1
        if frameCounter.isMultiple(of: 30) {
            let deltaTime: TimeInterval = 1.0

            if (frameCounter / 30) % 2 == 1 {
                entities.filter { $0 is Hero }.forEach {
                    let action = $0.update(deltaTime: deltaTime)
                    for var entity in entities {
                        action.apply(to: &entity)
                    }
                }
            } else {
                entities.filter { $0 is Monster }.forEach {
                    let action = $0.update(deltaTime: deltaTime)
                    for var entity in entities {
                        action.apply(to: &entity)
                    }
                }
            }

            removeDeadEntities()
        }
    }

    private func spawnHero(at tileX: Int, type: String = "hero") {
        let texture = SKTexture(imageNamed: type)
        let size = CGSize(width: tileSize, height: tileSize)

        let hero: Hero
        /*if type == "archer" {
            // hero = Archer(texture: texture, size: size, health: 80, attack: 5, speed: 5, manaCost: 15)
        } else {

        }*/
        hero = MeleeHero(texture: texture, size: size, hp: 100, speed: 30, baseAttack: 10, gameScene: self)

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
        let monster = BasicMonster(texture: texture, size: size, hp: 100, speed: 30.0, baseAttack: 30, gameScene: self)

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
        entities = entities.filter { entity in
            if !entity.isAlive {
                entity.removeFromParent()
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

//    // Handle touch movements
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            // Get the location of the touch in the scene
//            let location = touch.location(in: self)
//            // Update the player's position based on the touch location
//            playerNode.position.x = location.x
//            playerNode.position.y = location.y
//        }
//    }

    func subscribe(_ subscriber: any Subscriber<[(UUID, UUID)]>) {
        collisionSubscribers.append(subscriber)
    }

    func notifySubscribers() {
        for subscriber in collisionSubscribers {
            subscriber.update(entityCollisions)
        }
    }
}
