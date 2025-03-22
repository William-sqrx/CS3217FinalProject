//
//  GameCastle.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

class GameCastle: EntityNode {
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, health: 500, attack: 0, speed: 0.0, size: size)

        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = BitMask.Castle.playerCastle | BitMask.Castle.enemyCastle
        physicsBody.contactTestBitMask = BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage
        physicsBody.linearDamping = 50.0
        physicsBody.allowsRotation = false

        self.physicsBody = physicsBody
        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func takeDamage(_ amount: Int) {
        health -= amount
        if health <= 0 {
            removeFromParent()
        }
    }
}
