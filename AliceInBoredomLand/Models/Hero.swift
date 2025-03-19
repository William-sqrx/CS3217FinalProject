//
//  Hero.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Swift
import SpriteKit

class Hero: EntityNode {
    let cardID: UUID
    let manaCost: Int
    var tilePosition: Int = 0
    init(texture: SKTexture, size: CGSize, health: Int, attack: Int, speed: CGFloat, manaCost: Int) {
        self.cardID = UUID()
        self.manaCost = manaCost
        super.init(texture: texture, health: health, attack: attack, speed: speed, size: size)
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = BitMask.Hero.archer
        physicsBody.contactTestBitMask = BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage
        physicsBody.linearDamping = 50.0 
        
        self.physicsBody = physicsBody
        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: TimeInterval) {
        physicsBody?.velocity = CGVector(dx: speed, dy: 0)
    }
}
