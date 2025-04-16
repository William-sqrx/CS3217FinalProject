//
//  ActionPerformer.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

struct ActionPerformer {
    static func perform(_ action: Action, on target: GameEntity) {
        action.perform(on: target)
    }
}
