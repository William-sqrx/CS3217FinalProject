//
//  LevelEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SwiftUI
import SpriteKit

class LevelEntity: PhysicsBodySpecProvider, Renderable {
    var physicsBodySpec: PhysicsComponent
    var renderSpec: RenderSpec

    var position: CGPoint
    var velocity: CGVector = .zero
    var knockbackTimer: TimeInterval = 0.0
    var health: Int

    init(physicsBodySpec: PhysicsComponent, renderSpec: RenderSpec,
         position: CGPoint, velocity: CGVector, health: Int) {
        self.physicsBodySpec = physicsBodySpec
        self.renderSpec = renderSpec
        self.position = position
        self.velocity = velocity
        self.health = health
    }
}
