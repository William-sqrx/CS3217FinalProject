//
//  PhysicsCollisionHandlingDelegate.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

protocol PhysicsCollisionHandlingFacade {
    func handleCollision(from entity: PhysicsEntity, to otherEntity: PhysicsEntity)
    -> (PhysicsEntity, PhysicsEntity)
}
