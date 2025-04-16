//
//  Arrow.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SpriteKit

class Arrow: Projectile {
    static let arrowSize = CGSize(width: 20, height: 5)
    let maxRange: CGFloat = 800
    private var startPosition: CGPoint = .zero

    init(position: CGPoint, damage: Int, isPlayer: Bool) {
        let physics = PhysicsComponent(
            size: Arrow.arrowSize,
            isDynamic: true,
            categoryBitMask: 0,
            contactTestBitMask: isPlayer ? BitMask.enemyEntity : BitMask.playerEntity,
            collisionBitMask: isPlayer ? BitMask.enemyEntity : BitMask.playerEntity
        )

        super.init(textureName: "arrow", size: Arrow.arrowSize, position: position, isPlayer: isPlayer,
                   attack: damage, moveSpeed: 500,
                   physics: physics)
        self.startPosition = position
        self.physicsBody?.mass = 0 // Need to refactor into PhysicsComponent?
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        let distance = (position - startPosition).length()
        if distance >= maxRange {
            removeFromParent()
        }
    }
}
