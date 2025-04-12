//
//  DamageCastleAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation

struct DamageCastleAction: Action {
    let amount: Int
    let isPlayerCastle: Bool
    let logic: LevelLogicDelegate

    func perform(on node: LevelEntity) {
        if isPlayerCastle {
            logic.decrePlayerCastleHealth(amount: amount)
        } else {
            logic.decreMonsterCastleHealth(amount: amount)
        }
    }
}
