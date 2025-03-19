//
//  Arrow.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SpriteKit

class Arrow: SKSpriteNode {
    let damage: Int

    init(damage: Int) {
        self.damage = damage
        let texture = SKTexture(imageNamed: "arrow")
        super.init(texture: texture, color: .clear, size: CGSize(width: 20, height: 5))

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func launch(from position: CGPoint, direction: CGFloat) {
        self.position = position
        self.physicsBody?.velocity = CGVector(dx: speed * direction, dy: 0)
    }
}
