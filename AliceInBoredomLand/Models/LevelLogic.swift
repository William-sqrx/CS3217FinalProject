//
//  LevelLogic.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SwiftUI

class LevelLogic: ObservableObject, LevelLogicDelegate {
    @Published var playerCastleHealth: Int = 100
    @Published var monsterCastleHealth: Int = 100
    @Published var timeLeft: Int = 60
    @Published var mana: Int = 40
    var isWin: Bool { monsterCastleHealth <= 0 && playerCastleHealth > 0 }
    
    func increaseMana(by amount: Int) {
            mana += amount
    }

    func decreaseMana(by amount: Int) {
        mana -= amount
    }

    func reset() {
        playerCastleHealth = 100
        monsterCastleHealth = 100
        timeLeft = 60
        mana = 40
    }
}
