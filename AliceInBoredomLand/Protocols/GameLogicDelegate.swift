//
//  GameLogicDelegate.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

protocol GameLogicDelegate {
    var playerCastleHealth: Int { get }
    var isWin: Bool { get }
    var timeLeft: Int { get }
    mutating func decrePlayerCastleHealth() -> Void
    mutating func decreMonsterCastleHealth() -> Void
}
