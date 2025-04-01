//
//  Hero.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//
import Foundation

class Hero: GameEntity {
    var health: Int
    var attack: Int
    var speed: CGFloat
    var posX: CGFloat
    var posY: CGFloat

    var size: CGSize
    var physicsEntity: PhysicsEntity

    init(health: Int, attack: Int, speed: CGFloat, posX: CGFloat, posY: CGFloat, size: CGSize) {
        self.health = health
        self.attack = attack
        self.speed = speed
        self.posX = posX
        self.posY = posY
        self.size = size
        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: 0, velocityY: speed,
                                           width: size.width, height: size.height,
                                           entityCategories: PhysicsBitMask(PhysicsBitMask.playerEntity),
                                           collidesWith: PhysicsBitMask(PhysicsBitMask.enemyEntity))

        // self.userData = NSMutableDictionary()
        // self.userData?["entity"] = self
    }
}
