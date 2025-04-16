//
//  Hero.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import Foundation
import SpriteKit

class Hero: LevelEntity {
    var manaCost: Int
    var attackCooldown: TimeInterval = 0.1
    var attackRange: CGFloat = 500
    var lastAttackTime: TimeInterval = 0

    init(textureName: String, size: CGSize, position: CGPoint, health: Int, attack: Int, moveSpeed: CGFloat,
         manaCost: Int, physics: PhysicsComponent) {
        self.manaCost = manaCost
        super.init(textureName: textureName, size: size, position: position,
                   health: health, attack: attack, moveSpeed: moveSpeed,
                   physics: physics)
        self.name = "hero"
    }

    override func update(deltaTime: TimeInterval) {
        self.velocity = CGVector(dx: moveSpeed, dy: 0)
        super.update(deltaTime: deltaTime)
    }

    func shouldAttack(currentTime: TimeInterval) -> Bool {
        (currentTime - lastAttackTime) > attackCooldown
    }
}
