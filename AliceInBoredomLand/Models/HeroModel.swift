//
//  HeroModel.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 5/4/25.
//

import SpriteKit

class HeroModel: LevelEntity {
    var attack: Int
    var speed: CGFloat
    var manaCost: Int
    var physics: PhysicsComponent
    var lastAttackTime: TimeInterval = 0
    var attackCooldown: TimeInterval = 0.1
    var attackRange: CGFloat = 500
    var type: HeroType

    init(position: CGPoint, health: Int, attack: Int, speed: CGFloat, manaCost: Int,
         physics: PhysicsComponent, type: HeroType) {
        self.attack = attack
        self.speed = speed
        self.manaCost = manaCost
        self.physics = physics
        self.type = type

        let name: String

        switch type {
        case .archer:
            name = "archer"
        case .swordsman:
            name = "archer"
        case .tank:
            name = "archer"
        }
        let renderSpec = RenderSpec(
            textureName: name,
            size: physics.size,
            position: position,
            zPosition: 1,
            name: name
        )

        super.init(physicsBodySpec: physics, renderSpec: renderSpec,
                   position: position, velocity: .zero, health: health)
    }
}

struct HeroStats {
    let manaCost: Int
    let attack: Int
    let health: Int
    let speed: CGFloat
    let bitmask: UInt32
}

enum HeroType {
    case archer
    case swordsman
    case tank
}
