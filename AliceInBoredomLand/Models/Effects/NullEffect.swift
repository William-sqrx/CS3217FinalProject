//
//  NullEffect.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

struct NullEffect<Entity: GameEntity>: Effect {
    func apply(_ entity: inout Entity) {
    }
}
