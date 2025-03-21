//
//  NullAction.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

struct NullAction<G: GameEntity>: Action {
    var canSelect = TrueCondition()
    var canApply = FalseCondition()
    var effect = NullEffect<G>()
}
