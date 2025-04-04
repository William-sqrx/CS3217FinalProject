//
//  LevelViewModel.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

class LevelViewModel {
    var levelEngine: LevelEngineFacade
    var levelEntities: [LevelEntity] = []
    var levelLogic: LevelLogicFacade
    var tasks: [Task] = []
    var isWin: Bool = false
    var isLose: Bool = false

    init(levelEngine: LevelEngineFacade) {
        self.levelLogic = levelEngine.levelLogicDelegate
        self.levelEngine = levelEngine
    }

    func update(_ currentTime: TimeInterval) {
        levelEngine.update(currentTime)
        levelLogic = levelEngine.levelLogicDelegate
        levelEntities = levelEngine.entities
        tasks = levelEngine.tasks

        if levelEngine.levelLogicDelegate.isWin {
            isWin = true
        }

        if levelEngine.levelLogicDelegate.isLose {
            isLose = true
        }
    }

    func restartLevel() {
        isWin = false
        isLose = false
        levelEngine.restartLevel()
    }

    func spawnHero(atY: Int, type: String) {
        levelEngine.spawnHero(atY: atY, type: type)
    }

    func removeTask(_ task: Task) {
        levelEngine.removeTask(task)
    }
}
