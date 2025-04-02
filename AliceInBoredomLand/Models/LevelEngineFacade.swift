//
//  LevelEngineFacade.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

protocol LevelEngineFacade {
    var gameLogicDelegate: LevelLogicFacade { get set }
    var entities: [LevelEntity] { get set }
    var tasks: [Task] { get set }
    var isPaused: Bool { get set }

    func update(_ currentTime: TimeInterval)
    func spawnHero(atX tileX: Int, atY tileY: Int, type: String)
    func spawnMonster(atX tileX: Int, atY tileY: Int)
}
