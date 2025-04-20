//
//  GameEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 14/4/25.
//

import SpriteKit

// MARK: - Base Game Entity

/// The root class for all in-game entities.
/// Combines game logic, physics, and rendering into one object.
class GameEntity: GameEngineEntity, PhysicsBodySpecProvider, Renderable {
    var velocity: CGVector = .zero
    var health: Int
    var attack: Int
    var moveSpeed: CGFloat
    var knockbackTimer: TimeInterval = 0

    var renderNode: RenderNode
    let physicsBodySpec: PhysicsComponent

    init(textureName: String, size: CGSize, position: CGPoint, health: Int, attack: Int, moveSpeed: CGFloat, physics: PhysicsComponent) {
        self.health = health
        self.attack = attack
        self.moveSpeed = moveSpeed
        self.physicsBodySpec = physics

        let node = SpriteKitRenderNode(textureName: textureName, size: size, position: position, physics: physics)
        node.velocity = CGVector(dx: moveSpeed, dy: 0)
        self.renderNode = node
    }

    func update(deltaTime: TimeInterval) {
        knockbackTimer = max(0, knockbackTimer - deltaTime)
        if knockbackTimer == 0 {
            renderNode.velocity = velocity
        }
    }

    func takeDamage(_ amount: Int) {
        health -= amount
        if health <= 0 {
            renderNode.removeFromScene()
        }
    }

    func setRenderNode(to node: RenderNode) {
        self.renderNode = node
    }
}

