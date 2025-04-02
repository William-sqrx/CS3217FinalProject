//
//  GameEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Foundation

protocol GameEntity {
    var health: Int { get set }
    var attack: Int { get }
    var speed: CGFloat { get }
    var posX: CGFloat { get set }
    var posY: CGFloat { get set }
    var isAlive: Bool { get }

    var size: CGSize { get }
    var physicsEntity: PhysicsEntity { get set }

    mutating func update(dt: TimeInterval)

    mutating func takeDamage(_ amount: Int)
}

extension GameEntity {
    var isAlive: Bool {
        health > 0
    }
    var posX: CGFloat {
        get {
            physicsEntity.x
        }
        set {
            physicsEntity.x = newValue
        }
    }
    var posY: CGFloat {
        get {
            physicsEntity.y
        }
        set {
            physicsEntity.y = newValue
        }
    }

    mutating func update(dt: TimeInterval) {
    }

    mutating func takeDamage(_ amount: Int) {
        health -= amount
    }
}
