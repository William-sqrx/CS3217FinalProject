//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Foundation

class Monster: GameEntity {
    var health: Int
    var attack: Int
    var speed: CGFloat
    var posX: CGFloat
    var posY: CGFloat
    var width: Double
    var height: Double
    var physicsEntity: PhysicsEntity

    init(health: Int, attack: Int, speed: CGFloat, posX: CGFloat, posY: CGFloat, width: Double, height: Double) {
        self.health = health
        self.attack = attack
        self.speed = speed
        self.posX = posX
        self.posY = posY
        self.width = width
        self.height = height
        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: 0, velocityY: -speed,
                                           width: width, height: height,
                                           entityCategories: PhysicsBitMask(PhysicsBitMask.enemyEntity),
                                           collidesWith: PhysicsBitMask(PhysicsBitMask.playerEntity))

        // self.userData = NSMutableDictionary()
        // self.userData?["entity"] = self
    }
}
