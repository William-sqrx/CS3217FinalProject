//
//  LevelLogicDelegate.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 20/4/25.
//

protocol LevelLogicDelegate {
    var playerCastleHealth: Int { get }
    var monsterCastleHealth: Int { get }
    var timeLeft: Int { get }
    var isWin: Bool { get }
    func decreaseMana(by amount: Int)
    func reset()
}
