//
//  Swordsman.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Swordsman: Hero {
    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.playerEntity,
            contactTestBitMask: BitMask.enemyEntity,
            collisionBitMask: BitMask.enemyEntity
        )
        super.init(textureName: "swordsman", size: size, position: position, health: 100, attack: 50, moveSpeed: 20,
                   manaCost: 15, physics: physics)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
