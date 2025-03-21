//
//  FalseCondition.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

struct FalseCondition: Condition {
    func isSatisfied(entity: any GameEntity) -> Bool {
        false
    }
}
