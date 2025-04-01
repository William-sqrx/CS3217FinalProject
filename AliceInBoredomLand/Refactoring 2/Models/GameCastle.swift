//
//  GameCastle.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Foundation

class GameCastle: GameEntity {
    let isPlayer: Bool

    var health: Int
    var attack: Int
    var speed: CGFloat
    var posX: CGFloat
    var posY: CGFloat

    var width: Double
    var height: Double
    var physicsEntity: PhysicsEntity

    init(isPlayer: Bool, posX: CGFloat, posY: CGFloat, width: Double, height: Double) {
        self.isPlayer = isPlayer
        self.health = 500
        self.attack = 0
        self.speed = 0
        self.posX = posX
        self.posY = posY
        self.width = width
        self.height = height
        let entityCategories = PhysicsBitMask(isPlayer ? PhysicsBitMask.playerEntity : PhysicsBitMask.enemyEntity)
        let collidesWith = PhysicsBitMask(isPlayer ? PhysicsBitMask.enemyEntity : PhysicsBitMask.playerEntity)

        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: 0, velocityY: speed,
                                           width: width, height: height,
                                           entityCategories: entityCategories, collidesWith: collidesWith,
                                           affectsSelfOnCollision: false)

        // self.userData = NSMutableDictionary()
        // self.userData?["entity"] = self
    }
}
