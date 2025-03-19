//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

class Monster: EntityNode {
    var tilePosition: Int = 0
    init(texture: SKTexture, size: CGSize, health: Int, attack: Int, speed: CGFloat) {
        super.init(texture: texture, health: health, attack: attack, speed: speed, size: size)
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = BitMask.Monster.titan
        physicsBody.contactTestBitMask = BitMask.Hero.archer | BitMask.Hero.swordsman | BitMask.Hero.tanker
        
        self.physicsBody = physicsBody
        
        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime: TimeInterval) {
<<<<<<< HEAD
        physicsBody?.velocity = CGVector(dx: speed * -1, dy: 0)
=======
        let moveDistance = CGFloat(speed) * tileSize
        let newPosition = position.x + moveDistance * -1

        if newPosition > 0 {
            position.x = newPosition
        }
>>>>>>> 3945be4a506dd920c41be00a776492f0ee812118
    }
}
