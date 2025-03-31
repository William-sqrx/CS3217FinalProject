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
}
