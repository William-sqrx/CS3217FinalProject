//
//  PhysicsEvent.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

protocol PhysicsEvent {
    var physicsEntity: PhysicsEntity { get }
    var otherPhysicsEntity: PhysicsEntity { get }
}
