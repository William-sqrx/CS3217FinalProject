//
//  MonsterModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 1/4/25.
//

import Foundation

struct MonsterModel {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector = .zero
    var health: Int
    var attack: Int
    var speed: CGFloat
    var tilePosition: Int = 0
    var physics: PhysicsComponent
    var knockbackTimer: TimeInterval = 0
}

struct MonsterStats {
    let health: Int
    let attack: Int
    let speed: CGFloat
    let bitmask: UInt32
}

extension MonsterModel: Renderable {
    var renderSpec: RenderSpec {
        RenderSpec(
            textureName: "monster",
            size: physics.size,
            position: position,
            zPosition: 1,
            name: "monster"
        )
    }
}

extension MonsterModel: PhysicsBodySpecProvider {
    var physicsBodySpec: PhysicsComponent {
        physics
    }
}
