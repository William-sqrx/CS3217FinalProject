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

    func perform(on node: RenderNode, modelId: UUID) {
        if let logic = LevelModelRegistry.shared.gameLogicDelegate as? LevelLogic {
            if isPlayerCastle {
                logic.decrePlayerCastleHealth(amount: amount)
            } else {
                logic.decreMonsterCastleHealth(amount: amount)
            }
        }
    }
}
