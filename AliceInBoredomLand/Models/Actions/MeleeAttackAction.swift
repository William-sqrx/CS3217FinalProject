//
//  MeleeAttackAction.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

struct MeleeAttackAction<G: GameEntity & HP>: Action {
    var canSelect: CooldownCondition
    var canApply: CollisionCondition
    var effect: DamageEffect<G>
}
