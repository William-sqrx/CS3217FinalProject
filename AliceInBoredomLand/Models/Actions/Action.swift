//
//  Action.swift
//  AliceInBoredomLand
//
//  Created by daniel on 20/3/25.
//

import Foundation

protocol Action {
    associatedtype S: Condition
    associatedtype A: Condition
    associatedtype E: Effect
    var canSelect: S { get }
    var canApply: A { get }
    var effect: E { get }

    func apply(to: inout GameEntity)
}

extension Action {
    func apply(to entity: inout GameEntity) {
        guard var entity = entity as? E.G else {
            return
        }

        if canApply.isSatisfied(entity: entity) {
            effect.apply(&entity)
        }
    }
}
