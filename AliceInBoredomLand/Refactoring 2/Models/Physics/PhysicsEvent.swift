//
//  PhysicsEvent.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

struct PhysicsEvent {
    var entityA: PhysicsEntity
    var entityB: PhysicsEntity
}

extension PhysicsEvent: Equatable {
}
