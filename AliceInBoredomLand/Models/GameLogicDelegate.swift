//
//  GameLogicDelegate.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

// Intentional invocation of Protocol-Delegate Pattern here, weak ref not needed here
// swiftlint:disable class_delegate_protocol
protocol GameLogicDelegate {
    var playerCastleHealth: Int { get }
    var isWin: Bool { get }
    var timeLeft: Int { get }

    func decrePlayerCastleHealth()
    func decreMonsterCastleHealth()
}
// swiftlint:enable class_delegate_protocol
