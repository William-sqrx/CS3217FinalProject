//
//  LevelLogicFacade.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

protocol LevelLogicFacade {
    var monsterCastleHealth: Int { get }
    var playerCastleHealth: Int { get }
    var isWin: Bool { get }
    var isLose: Bool { get }
    var timeLeft: Int { get }
    var mana: Int { get }

    func decrePlayerCastleHealth(amount: Int)
    func decreMonsterCastleHealth(amount: Int)
    func increaseMana(by amount: Int)
    func decreaseMana(by amouunt: Int)

    func reset()
}
