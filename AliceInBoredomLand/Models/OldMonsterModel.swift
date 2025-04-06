//
//  OldMonsterModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 1/4/25.
//

import Foundation

struct MonsterStats {
    let health: Int
    let attack: Int
    let speed: CGFloat
    let bitmask: UInt32
}


struct OldMonsterModel {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector = .zero
    var health: Int
    var attack: Int
    var speed: CGFloat
    var tilePosition: Int = 0
    var physics: OldPhysicsComponent
    var knockbackTimer: TimeInterval = 0
}

extension OldMonsterModel: Renderable {
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

extension OldMonsterModel: PhysicsBodySpecProvider {
    var physicsBodySpec: OldPhysicsComponent {
        physics
    }
}
