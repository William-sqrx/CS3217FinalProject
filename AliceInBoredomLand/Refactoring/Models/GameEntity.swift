//
//  GameEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Foundation

protocol GameEntity {
    var id: UUID { get }
    func update(deltaTime: TimeInterval) // Movement is currently distinct from Actions, this may change in the future
    func selectAction() -> Action

    var isVisible: Bool { get }
    var isAlive: Bool { get }
}

extension GameEntity {
    var isVisible: Bool { true }
}
