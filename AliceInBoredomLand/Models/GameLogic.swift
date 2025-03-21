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

    func decrePlayerCastleHealth() {
        if playerCastleHealth > 0 {
            playerCastleHealth -= 1
        }
    }

    func decreMonsterCastleHealth() {
        if monsterCastleHealth > 0 {
            monsterCastleHealth -= 1
        }
    }
}
