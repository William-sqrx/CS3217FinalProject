//
//  PhysicsEntity.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

// Assumes that the corresponding collision area is a square rectangle for the time being
protocol PhysicsEntity {
    var x: Double { get set }
    var y: Double { get set }
    var velocityX: Double { get set }
    var velocityY: Double { get set }
    var width: Double { get set }
    var height: Double { get set }

    var entityCategories: PhysicsBitMask { get }
    var collidesWith: PhysicsBitMask { get set }
    var notifiesCollisionsWith: PhysicsBitMask { get set }
    var affectsSelfOnCollision: Bool { get }
    var affectsOthersOnCollision: Bool { get }
}
