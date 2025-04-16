//
//  Archer.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Archer: Hero {
    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.playerEntity,
            contactTestBitMask: BitMask.enemyEntity,
            collisionBitMask: BitMask.enemyEntity
        )
        super.init(textureName: "archer", size: size, position: position, health: 90, attack: 2, moveSpeed: 25,
                   manaCost: 10, physics: physics)
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)

        // Insert archer-specific attack logic (e.g., range check + spawn arrow)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
