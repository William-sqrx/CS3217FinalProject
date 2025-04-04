//
//  LevelEngineFacade.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

protocol LevelEngineFacade {
    var levelLogicDelegate: LevelLogicFacade { get set }
    var entities: [LevelEntity] { get set }
    var tasks: [Task] { get set }
    var isPaused: Bool { get set }
    var isWin: Bool { get }
    var isLose: Bool { get }

    func update(_ currentTime: TimeInterval)
    func spawnHero(atY tileY: Int, type: String)
    func spawnMonster(atY tileY: Int)
    func removeTask(_ task: Task)

    func restartLevel()
}
