//
//  OldGameCastleModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 5/4/25.
//

import Foundation

struct OldGameCastleModel {
    let id = UUID()
    var position: CGPoint
    var health: Int
    var isPlayer: Bool
    var physics: OldPhysicsComponent
    var textureName: String
}

extension OldGameCastleModel: Renderable {
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
extension OldGameCastleModel: PhysicsBodySpecProvider {
    var physicsBodySpec: OldPhysicsComponent {
        physics
    }
}
