//
//  Tank.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Tank: Hero, EntityCreatable {
    static let defaultHealth = 200
    static let defaultAttack = 2
    static let defaultMoveSpeed: CGFloat = 20
    static let defaultManaCost = 20

    static var typeName: String { String(describing: Self.self).lowercased() }

    static func create(position: CGPoint, size: CGSize) -> GameEntity {
        return Tank(position: position, size: size)
    }

    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.playerEntity,
            contactTestBitMask: BitMask.enemyEntity,
            collisionBitMask: BitMask.enemyEntity
        )
        super.init(
            textureName: Tank.typeName,
            size: size,
            position: position,
            health: Tank.defaultHealth,
            attack: Tank.defaultAttack,
            moveSpeed: Tank.defaultMoveSpeed,
            manaCost: Tank.defaultManaCost,
            physics: physics
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Tank: GridSpawnable {
    static func spawn(at tileX: Int, tileY: Int, grid: Grid) -> GameEntity {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: tileY))
        return Tank(position: pos, size: size)
    }
}
