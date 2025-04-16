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
class GameEntity: SKSpriteNode {
    var velocity: CGVector = .zero
    var health: Int
    var attack: Int
    var moveSpeed: CGFloat
    var knockbackTimer: TimeInterval = 0

    init(textureName: String, size: CGSize, position: CGPoint, health: Int, attack: Int,
         moveSpeed: CGFloat, physics: PhysicsComponent) {
        let texture = SKTexture(imageNamed: textureName)
        self.health = health
        self.attack = attack
        self.moveSpeed = moveSpeed
        super.init(texture: texture, color: .clear, size: size)
        self.position = position
        self.name = "entity"
        self.zPosition = 1
        self.setupPhysics(using: physics)
    }

    private func setupPhysics(using component: PhysicsComponent) {
        self.physicsBody = SKPhysicsBody(rectangleOf: component.size)
        self.physicsBody?.isDynamic = component.isDynamic
        self.physicsBody?.categoryBitMask = component.categoryBitMask
        self.physicsBody?.contactTestBitMask = component.contactTestBitMask
        self.physicsBody?.collisionBitMask = component.collisionBitMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(deltaTime: TimeInterval) {
        knockbackTimer = max(0, knockbackTimer - deltaTime)
        if knockbackTimer == 0 {
            physicsBody?.velocity = velocity
        }
    }

    func takeDamage(_ amount: Int) {
        health -= amount
        if health <= 0 {
            removeFromParent()
        }
    }
}
