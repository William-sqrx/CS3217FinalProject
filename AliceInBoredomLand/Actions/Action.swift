//
//  Action.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

/// Base protocol for all actions an entity can perform.
protocol Action {
    func perform(on target: GameEntity)
}
