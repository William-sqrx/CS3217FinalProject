//
//  GameEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

protocol GameEntity: SKSpriteNode {
    var id: UUID { get }
    var size: CGSize { get }
    // Note: Movement is currently distinct from Actions, which may change
    func update(deltaTime: TimeInterval) -> any Action
    var possibleActions: [any Action] { get set }
    var globalCooldown: Int { get set }
    func selectAction() -> any Action
    func collides(with other: GameEntity) -> Bool

    var isVisible: Bool { get }
    var isAlive: Bool { get }
}

extension GameEntity {
    var isVisible: Bool { true }
}
