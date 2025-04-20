//
//  PhysicsFactory.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/4/25.
//

import SpriteKit

struct PhysicsFactory {
    static func hero(size: CGSize) -> PhysicsComponent {
        PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.playerEntity,
            contactTestBitMask: BitMask.enemyEntity,
            collisionBitMask: BitMask.enemyEntity
        )
    }

    static func monster(size: CGSize) -> PhysicsComponent {
        PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.enemyEntity,
            contactTestBitMask: BitMask.playerEntity,
            collisionBitMask: BitMask.playerEntity
        )
    }

    static func castle(size: CGSize, isPlayer: Bool) -> PhysicsComponent {
        PhysicsComponent(
            size: size,
            isDynamic: false,
            categoryBitMask: isPlayer ? BitMask.playerEntity : BitMask.enemyEntity,
            contactTestBitMask: isPlayer ? BitMask.enemyEntity : BitMask.playerEntity,
            collisionBitMask: isPlayer ? BitMask.enemyEntity : BitMask.playerEntity
        )
    }
}
