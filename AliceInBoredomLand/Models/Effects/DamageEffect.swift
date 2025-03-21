//
//  DamageEffect.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

struct DamageEffect<Entity: GameEntity & HP>: Effect {
    let amount: Int

    func apply(_ entity: inout Entity) {
        entity.decreaseHP(amount)
    }
}
