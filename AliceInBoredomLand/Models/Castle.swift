//
//  Castle.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Castle: GameEntity {
    static let defaultHealth = 10000
    static let defaultAttack = 0
    static let defaultMoveSpeed: CGFloat = 0

    static var typeName: String { String(describing: Self.self).lowercased() }

    init(position: CGPoint, size: CGSize, isPlayer: Bool) {
        let textureName = isPlayer ? "player-castle" : "enemy-castle"
        let physics = PhysicsFactory.castle(size: size, isPlayer: isPlayer)
        super.init(
            textureName: textureName,
            size: size,
            position: position,
            health: Castle.defaultHealth,
            attack: Castle.defaultAttack,
            moveSpeed: Castle.defaultMoveSpeed,
            physics: physics
        )
        self.renderNode.name = isPlayer ? "player-castle" : "monster-castle"
    }
}
