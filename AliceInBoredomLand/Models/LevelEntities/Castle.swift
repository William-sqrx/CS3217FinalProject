//
//  Castle.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Foundation

class Castle: LevelEntity {
    let isPlayer: Bool

    var health: Int
    var attack: Int
    var speed: CGFloat

    var size: CGSize
    var physicsEntity: PhysicsEntity

    init(isPlayer: Bool, posX: CGFloat, posY: CGFloat, size: CGSize) {
        self.isPlayer = isPlayer
        self.health = 500
        self.attack = 0
        self.speed = 0
        self.size = size
        let entityCategories = PhysicsBitMask(isPlayer ? PhysicsBitMask.playerEntity : PhysicsBitMask.enemyEntity)
        let collidesWith = PhysicsBitMask(isPlayer ? PhysicsBitMask.enemyEntity : PhysicsBitMask.playerEntity)

        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: 0, velocityY: speed,
                                           width: size.width, height: size.height,
                                           entityCategories: entityCategories, collidesWith: collidesWith,
                                           affectsSelfOnCollision: false)
    }
}
