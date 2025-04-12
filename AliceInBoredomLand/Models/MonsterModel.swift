//
//  MonsterModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 1/4/25.
//

import Foundation

class MonsterModel: LevelEntity {
    var attack: Int
    var speed: CGFloat
    var physics: PhysicsComponent

    init(position: CGPoint, health: Int, attack: Int, speed: CGFloat,
         physics: PhysicsComponent) {
        self.attack = attack
        self.speed = speed
        self.physics = physics

        let renderSpec = RenderSpec(
            textureName: "monster",
            size: physics.size,
            position: position,
            zPosition: 1,
            name: "monster"
        )

        super.init(physicsBodySpec: physics, renderSpec: renderSpec,
                   position: position, velocity: .zero, health: health)
    }
}

struct MonsterStats {
    let health: Int
    let attack: Int
    let speed: CGFloat
    let bitmask: UInt32
}
