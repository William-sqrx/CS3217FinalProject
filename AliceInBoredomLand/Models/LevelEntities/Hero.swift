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
    var attackCooldown: TimeInterval
    var attackRange: CGFloat
    var lastAttackTime: TimeInterval = 0

    static let defaultAttackCooldown: TimeInterval = 0.1
    static let defaultAttackRange: CGFloat = 500

    init(
        textureName: String,
        size: CGSize,
        position: CGPoint,
        health: Int,
        attack: Int,
        moveSpeed: CGFloat,
        manaCost: Int,
        physics: PhysicsComponent,
        attackCooldown: TimeInterval = Hero.defaultAttackCooldown,
        attackRange: CGFloat = Hero.defaultAttackRange
    ) {
        self.manaCost = manaCost
        self.attackCooldown = attackCooldown
        self.attackRange = attackRange
        super.init(textureName: textureName, size: size, position: position, health: health, attack: attack, moveSpeed: moveSpeed, physics: physics)
        self.renderNode.name = "hero"
    }

    override func update(deltaTime: TimeInterval) {
        self.velocity = CGVector(dx: moveSpeed, dy: 0)
        super.update(deltaTime: deltaTime)
    }

    func shouldAttack(currentTime: TimeInterval) -> Bool {
        (currentTime - lastAttackTime) > attackCooldown
    }
}
