//
//  LevelViewModel.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

class LevelViewModel: ObservableObject {
    var levelEngine: LevelEngineFacade
    @Published var levelEntities: [LevelEntity] = []
    @Published var tasks: [Task] = []

    init(levelEngine: LevelEngineFacade) {
        self.levelEngine = levelEngine
    }

    func update(_ currentTime: TimeInterval) {
        levelEngine.update(currentTime)
        levelEntities = levelEngine.entities
        tasks = levelEngine.tasks
    }
}
