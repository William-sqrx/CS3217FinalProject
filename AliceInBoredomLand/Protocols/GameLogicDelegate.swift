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
<<<<<<< HEAD
    func decrePlayerCastleHealth() -> Void
    func decreMonsterCastleHealth() -> Void
=======
    mutating func decrePlayerCastleHealth() -> Void
    mutating func decreMonsterCastleHealth() -> Void
>>>>>>> 3945be4a506dd920c41be00a776492f0ee812118
}
