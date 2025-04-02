//
//  PhysicsCollisionHandlingDelegate.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

// Intentional invocation of Protocol-Delegate Pattern here, weak ref not needed here
// swiftlint:disable class_delegate_protocol
protocol PhysicsCollisionHandlingDelegate {
    func handleCollision(from entity: PhysicsEntity, to otherEntity: PhysicsEntity)
    -> (PhysicsEntity, PhysicsEntity)
}
// swiftlint:enable class_delegate_protocol
