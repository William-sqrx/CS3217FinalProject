//
//  Swordsman.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

import Foundation
import SpriteKit

class Swordsman: Hero, EntityCreatable {
    static let defaultHealth = 100
    static let defaultAttack = 50
    static let defaultMoveSpeed: CGFloat = 20
    static let defaultManaCost = 15

    static var typeName: String { String(describing: Self.self).lowercased() }

    static func create(position: CGPoint, size: CGSize) -> GameEntity {
        return Swordsman(position: position, size: size)
    }

    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsFactory.hero(size: size)
        super.init(
            textureName: Swordsman.typeName,
            size: size,
            position: position,
            health: Swordsman.defaultHealth,
            attack: Swordsman.defaultAttack,
            moveSpeed: Swordsman.defaultMoveSpeed,
            manaCost: Swordsman.defaultManaCost,
            physics: physics
        )
<<<<<<< HEAD
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
=======
        super.init(textureName: "swordsman", size: size, position: position,
                   health: 100, attack: 50, moveSpeed: 20, manaCost: 15,
                   physics: physics)
>>>>>>> 26c767df24ddb08540903dea7855e5478b35718d
    }
}

extension Swordsman: GridSpawnable {
    static func spawn(at tileX: Int, tileY: Int, grid: Grid) -> GameEntity {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: tileY))
        return Swordsman(position: pos, size: size)
    }
}
