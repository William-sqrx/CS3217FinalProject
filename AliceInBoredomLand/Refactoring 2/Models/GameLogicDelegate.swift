//
//  GameLogicDelegate.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

// Intentional invocation of Protocol-Delegate Pattern here, weak ref not needed here
// swiftlint:disable class_delegate_protocol
protocol GameLogicDelegate {
    var monsterCastleHealth: Int { get }
    var playerCastleHealth: Int { get }
    var isWin: Bool { get }
    var timeLeft: Int { get }
    var mana: Int { get }

    func decrePlayerCastleHealth(amount: Int)
    func decreMonsterCastleHealth(amount: Int)
    func increaseMana(by amount: Int)
    func decreaseMana(by amouunt: Int)

    func reset()
}
// swiftlint:enable class_delegate_protocol
