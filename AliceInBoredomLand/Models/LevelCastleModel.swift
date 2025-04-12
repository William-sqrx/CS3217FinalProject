//
//  LevelCastleModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 5/4/25.
//

import Foundation

class LevelCastleModel: LevelEntity {
    var physics: PhysicsComponent
    var isPlayer: Bool

    var textureName: String

    init(position: CGPoint, health: Int, isPlayer: Bool, physics: PhysicsComponent, textureName: String) {
        self.isPlayer = isPlayer
        self.physics = physics
        self.textureName = textureName

        let renderSpec = RenderSpec(
            textureName: textureName,
            size: physics.size,
            position: position,
            zPosition: 1,
            name: isPlayer ? "player-castle" : "monster-castle"
        )

        super.init(physicsBodySpec: physics, renderSpec: renderSpec, position: position, velocity: .zero, health: health)
    }
}
