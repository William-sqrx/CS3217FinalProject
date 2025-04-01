//
//  PhysicsEntity.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

// Assumes that the corresponding collision area is a square rectangle for the time being
struct PhysicsEntity {
    var x: Double
    var y: Double
    var velocityX: Double
    var velocityY: Double
    var width: Double
    var height: Double

    var entityCategories: PhysicsBitMask
    var collidesWith: PhysicsBitMask
    var notifiesCollisionsWith: PhysicsBitMask
    var affectsSelfOnCollision: Bool
    let affectsOthersOnCollision: Bool

    init(x: Double, y: Double, velocityX: Double, velocityY: Double, width: Double, height: Double,
         entityCategories: PhysicsBitMask, collidesWith: PhysicsBitMask, notifiesCollisionsWith: PhysicsBitMask,
         affectsSelfOnCollision: Bool = true, affectsOthersOnCollision: Bool = true) {
        self.x = x
        self.y = y
        self.velocityX = velocityX
        self.velocityY = velocityY
        self.width = width
        self.height = height
        self.entityCategories = entityCategories
        self.collidesWith = collidesWith
        self.notifiesCollisionsWith = notifiesCollisionsWith
        self.affectsSelfOnCollision = affectsSelfOnCollision
        self.affectsOthersOnCollision = affectsOthersOnCollision
    }

    init(x: Double, y: Double, velocityX: Double, velocityY: Double, width: Double, height: Double,
         entityCategories: PhysicsBitMask, collidesWith: PhysicsBitMask,
         affectsSelfOnCollision: Bool = true, affectsOthersOnCollision: Bool = true) {
        self.init(x: x, y: y, velocityX: velocityX, velocityY: velocityY, width: width, height: height,
                  entityCategories: entityCategories, collidesWith: collidesWith, notifiesCollisionsWith: collidesWith,
                  affectsSelfOnCollision: affectsSelfOnCollision, affectsOthersOnCollision: affectsOthersOnCollision)
    }
}

extension PhysicsEntity: Equatable {
}
