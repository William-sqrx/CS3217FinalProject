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
    
    init(gameLogicDelegate: GameLogicDelegate,
         scaleMode: SKSceneScaleMode = .fill,
         background: SKColor = .black,
         size: CGSize = CGSize(width: GameScene.width, height: GameScene.height)) {

            self.gameLogicDelegate = gameLogicDelegate
            self.entities = []
            super.init(size: CGSize(width: CGFloat(gridWidth) * tileSize, height: tileSize))
            self.scaleMode = scaleMode
            self.backgroundColor = background
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = 1.0 / 60.0
        entities.forEach { $0.update(deltaTime: deltaTime) }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Ops, bad inicialization :(")
    }
    
    private func spawnHero(at tileX: Int) {
        let texture = SKTexture(imageNamed: "monster")
        let hero = Hero(texture: texture, health: 100, attack: 20, speed: 1.0, manaCost: 10)
        hero.position = CGPoint(x: CGFloat(tileX) * tileSize, y: size.height / 2)
        hero.zPosition = 2

        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize, height: tileSize))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BitMask.Hero.archer
    
        addChild(hero)
        entities.append(hero)
    }
    
    private func spawnMonster(at tileX: Int) {
        let texture = SKTexture(imageNamed: "monster")
        let monster = Monster(texture: texture, health: 100, attack: 10, speed: 1.0)
        monster.position = CGPoint(x: CGFloat(tileX) * tileSize, y: size.height / 2)
        monster.zPosition = 2

        monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize, height: tileSize))
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = BitMask.Monster.titan
    
        addChild(monster)
        entities.append(monster)
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
    
    private func handleCollisions() {
    }
}
