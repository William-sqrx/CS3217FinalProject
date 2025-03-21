//
//  CooldownCondition.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

struct CooldownCondition: Condition {
    let specificCooldown: Int?

    func isSatisfied(entity: any GameEntity) -> Bool {
        entity.globalCooldown <= 0
    }
}
