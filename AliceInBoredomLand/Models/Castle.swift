//
//  Castle.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Castle: GameEntity {
    let isPlayer: Bool

    init(position: CGPoint, size: CGSize, isPlayer: Bool) {
        self.isPlayer = isPlayer
        let textureName = isPlayer ? "player-castle" : "enemy-castle"
        let physics = PhysicsComponent(
            size: size,
            isDynamic: false,
            categoryBitMask: isPlayer ? BitMask.playerEntity : BitMask.enemyEntity,
            contactTestBitMask: isPlayer ? BitMask.enemyEntity : BitMask.playerEntity,
            collisionBitMask: isPlayer ? BitMask.enemyEntity : BitMask.playerEntity
        )
        super.init(textureName: textureName, size: size, position: position, health: 500, attack: 0,
                   moveSpeed: 0, physics: physics)
        self.name = isPlayer ? "player-castle" : "monster-castle"
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
