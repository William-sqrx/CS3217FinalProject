//
//  ActionPerformer.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation

struct ActionPerformer {
    static func perform(_ action: Action, on node: LevelEntity) {
        action.perform(on: node)
    }
}
