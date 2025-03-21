//
//  GameLogic.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SwiftUI

class GameLogic: ObservableObject {
    @Published var playerCastleHealth: Int = 100
    @Published var monsterCastleHealth: Int = 100
    @Published var timeLeft: Int = 60

    var isWin: Bool {
        monsterCastleHealth <= 0 && playerCastleHealth > 0
    }
}

extension GameLogic: GameLogicDelegate {

    func decrePlayerCastleHealth(amount: Int) {
        if playerCastleHealth > 0 {
            playerCastleHealth -= amount
        }
    }

    func decreMonsterCastleHealth(amount: Int) {
        if monsterCastleHealth > 0 {
            monsterCastleHealth -= amount
        }
    }
}
