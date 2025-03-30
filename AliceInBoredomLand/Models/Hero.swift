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
    private var initialY: CGFloat
    init(texture: SKTexture, size: CGSize, health: Int, attack: Int, speed: CGFloat, manaCost: Int) {
        self.cardID = UUID()
        self.manaCost = manaCost
        self.initialY = 0
        super.init(texture: texture, health: health, attack: attack, speed: speed, size: size)
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = true
        physicsBody.contactTestBitMask = OldBitMask.Monster.titan | OldBitMask.Monster.minion | OldBitMask.Monster.mage
            | OldBitMask.Castle.playerCastle | OldBitMask.Castle.enemyCastle
        physicsBody.collisionBitMask = OldBitMask.Monster.titan | OldBitMask.Monster.minion | OldBitMask.Monster.mage
            | OldBitMask.Castle.playerCastle | OldBitMask.Castle.enemyCastle
        physicsBody.allowsRotation = false

        self.physicsBody = physicsBody
        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime: TimeInterval) {
        if initialY == 0 { initialY = position.y }
        position.y = initialY
        physicsBody?.velocity = CGVector(dx: speed, dy: 0)
    }
}
