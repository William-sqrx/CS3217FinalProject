//
//  GameEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SwiftUI
import SpriteKit

protocol GameEntity {
    var health: Int { get set }
    var attack: Int { get }
    var speed: CGFloat { get }
    var posX: CGFloat { get set }
    var posY: CGFloat { get set }
    var isAlive: Bool { get }

    var width: Double { get }
    var height: Double { get }
    var physicsEntity: PhysicsEntity { get set }

    mutating func takeDamage(_ amount: Int)
}

extension GameEntity {
    var isAlive: Bool {
        health > 0
    }
    mutating func takeDamage(_ amount: Int) {
        health -= amount
    }
}
