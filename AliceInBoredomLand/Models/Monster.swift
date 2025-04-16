//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Monster: GameEntity {
    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.enemyEntity,
            contactTestBitMask: BitMask.playerEntity,
            collisionBitMask: BitMask.playerEntity
        )
        super.init(textureName: "monster", size: size, position: position,
                   health: 100, attack: 1_000, moveSpeed: 20,
                   physics: physics)
        self.name = "monster"
    }

    override func update(deltaTime: TimeInterval) {
        self.velocity = CGVector(dx: -moveSpeed, dy: 0)
        super.update(deltaTime: deltaTime)
    }
}
