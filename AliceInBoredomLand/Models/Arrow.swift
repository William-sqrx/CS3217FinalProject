//
//  Arrow.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SpriteKit

class Arrow: SKSpriteNode {
    let damage: Int
    let maxRange: CGFloat = 800
    private var startPosition: CGPoint

    init(damage: Int) {
        self.damage = damage
        let texture = SKTexture(imageNamed: "arrow")
        startPosition = .zero
        super.init(texture: texture, color: .clear, size: CGSize(width: 20, height: 5))

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage
        | BitMask.Castle.playerCastle | BitMask.Castle.enemyCastle
        self.physicsBody?.collisionBitMask = 0
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func launch(from position: CGPoint, direction: CGFloat) {
        self.position = position
        self.startPosition = position

        self.physicsBody?.velocity = CGVector(dx: 500 * direction, dy: 0)
    }

    func updateArrow(deltaTime: TimeInterval) {
        let distTraveled = (self.position - startPosition).length()
        if distTraveled >= maxRange {
            self.removeFromParent()
        }
    }
}
