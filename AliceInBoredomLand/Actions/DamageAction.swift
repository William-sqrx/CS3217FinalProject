//
//  DamageAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation

struct DamageAction: Action {
    let amount: Int

    func perform(on node: LevelEntity) {
        node.health -= amount
        print("⚠️ Node took \(amount) damage. Remaining: \(node.health)")
        if node.health <= 0 {
            // node.renderSpec.remove()
        }

    }
}
