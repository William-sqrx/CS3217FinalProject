//
//  Condition.swift
//  AliceInBoredomLand
//
//  Created by daniel on 20/3/25.
//

import Foundation

protocol Condition: Equatable {
    func isSatisfied(entity: GameEntity) -> Bool
}
