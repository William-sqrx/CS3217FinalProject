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
    func perform(on node: SKSpriteNode, modelId: UUID) {
        if let logic = GameModelRegistry.shared.gameLogicDelegate as? GameLogic {
            if isPlayerCastle {
                logic.decrePlayerCastleHealth(amount: amount)
            } else {
                logic.decreMonsterCastleHealth(amount: amount)
            }
        }
    }
}
