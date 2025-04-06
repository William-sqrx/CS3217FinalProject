//
//  LevelCastleModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 5/4/25.
//

import Foundation

struct LevelCastleModel {
    let id = UUID()
    var position: CGPoint
    var health: Int
    var isPlayer: Bool
    var physics: PhysicsComponent
    var textureName: String
}

extension LevelCastleModel: Renderable {
    var renderSpec: RenderSpec {
        RenderSpec(
            textureName: textureName,
            size: physics.size,
            position: position,
            zPosition: 1,
            name: isPlayer ? "player-castle" : "monster-castle"
        )
    }
}

// 2. Conform to PhysicsBodySpecProvider
extension LevelCastleModel: PhysicsBodySpecProvider {
    var physicsBodySpec: PhysicsComponent {
        physics
    }
}
