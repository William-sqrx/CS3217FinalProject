//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Monster: GameEntity, EntityCreatable {
    static let defaultHealth = 100
    static let defaultAttack = 1000
    static let defaultMoveSpeed: CGFloat = 20

    static var typeName: String { String(describing: Self.self).lowercased() }

    static func create(position: CGPoint, size: CGSize) -> GameEntity {
        return Monster(position: position, size: size)
    }

    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsFactory.monster(size: size)
        super.init(
            textureName: Monster.typeName,
            size: size,
            position: position,
            health: Monster.defaultHealth,
            attack: Monster.defaultAttack,
            moveSpeed: Monster.defaultMoveSpeed,
            physics: physics
        )
        self.renderNode.name = Monster.typeName
    }

    override func update(deltaTime: TimeInterval) {
        self.velocity = CGVector(dx: -Monster.defaultMoveSpeed, dy: 0)
        super.update(deltaTime: deltaTime)
    }
}

extension Monster: GridSpawnable {
    static func spawn(at tileX: Int, tileY: Int, grid: Grid) -> GameEntity {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: tileY))
        return Monster(position: pos, size: size)
    }
}
