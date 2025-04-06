//
//  LevelEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SwiftUI
import SpriteKit

protocol LevelEntity {
    var id: UUID { get }
    var health: Int { get set }
    var attack: Int { get }
    var speed: CGFloat { get }
    var node: SKSpriteNode { get }

    func update(deltaTime: TimeInterval)
    func takeDamage(_ amount: Int)
    var isAlive: Bool { get }
}
