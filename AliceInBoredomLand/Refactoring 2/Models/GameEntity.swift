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

    func update(deltaTime: TimeInterval)
    func takeDamage(_ amount: Int)
    var isAlive: Bool { get }
}
