//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Foundation

class Monster: LevelEntity {
    var health: Int
    var attack: Int
    var speed: CGFloat

    var size: CGSize
    var physicsEntity: PhysicsEntity

    init(health: Int, attack: Int, speed: CGFloat, posX: CGFloat, posY: CGFloat, size: CGSize) {
        self.health = health
        self.attack = attack
        self.speed = speed
        self.size = size
        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: -speed, velocityY: 0,
                                           width: size.width, height: size.height,
                                           entityCategories: PhysicsBitMask(PhysicsBitMask.enemyEntity),
                                           collidesWith: PhysicsBitMask(PhysicsBitMask.playerEntity))
    }

    func update(dt: TimeInterval) {
        physicsEntity.velocityX = -speed
    }
}
