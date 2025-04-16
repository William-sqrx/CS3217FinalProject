//
//  DamageCastleAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

struct DamageCastleAction: Action {
    let amount: Int
    let isPlayerCastle: Bool
    let logic: LevelLogic

    func perform(on target: LevelEntity) {
        if isPlayerCastle {
            logic.playerCastleHealth -= amount
        } else {
            logic.monsterCastleHealth -= amount
        }
    }
}
