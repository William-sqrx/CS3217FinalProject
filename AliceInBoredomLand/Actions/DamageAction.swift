//
//  DamageAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

struct DamageAction: Action {
    let amount: Int
    func perform(on target: GameEntity) {
        target.takeDamage(amount)
    }
}
