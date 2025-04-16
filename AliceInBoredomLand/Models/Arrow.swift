//
//  Arrow.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SpriteKit

class Arrow: GameEntity {
    let maxRange: CGFloat = 800
    private var startPosition: CGPoint = .zero

    init(position: CGPoint, damage: Int) {
        let size = CGSize(width: 20, height: 5)
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: 0,
            contactTestBitMask: BitMask.enemyEntity,
            collisionBitMask: 0
        )
        super.init(textureName: "arrow", size: size, position: position, health: 1, attack: damage,
                   moveSpeed: 0, physics: physics)
        self.name = "arrow"
        self.startPosition = position
        self.physicsBody?.mass = 0
        self.velocity = CGVector(dx: 500, dy: 0)
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        let distance = (position - startPosition).length()
        if distance >= maxRange {
            removeFromParent()
        }
    }
}
