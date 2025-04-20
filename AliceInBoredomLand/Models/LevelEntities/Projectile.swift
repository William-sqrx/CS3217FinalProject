//
//  Projectile.swift
//  AliceInBoredomLand
//
//  Created by daniel on 16/4/25.
//

import Foundation

class Projectile: LevelEntity {
    let isPlayer: Bool

    init(textureName: String, size: CGSize, position: CGPoint, isPlayer: Bool,
         attack: Int, moveSpeed: CGFloat,
         physics: PhysicsComponent) {
        self.isPlayer = isPlayer
        super.init(textureName: textureName, size: size, position: position,
                   health: 1, attack: attack, moveSpeed: moveSpeed,
                   physics: physics)
        self.name = "projectile"

    }

    override func update(deltaTime: TimeInterval) {
        self.velocity = CGVector(dx: isPlayer ? moveSpeed : -moveSpeed, dy: 0)
        super.update(deltaTime: deltaTime)
    }
}
