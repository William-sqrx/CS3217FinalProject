//
//  EntityNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

class EntityNode: SKSpriteNode, GameEntity {
    let id = UUID()
    var health: Int
    let attack: Int
    var node: SKSpriteNode { self }
    override var speed: CGFloat {
        get { super.speed }
        set { super.speed = newValue }
    }

    var isAlive: Bool { health > 0 }
<<<<<<< HEAD
    
    init(texture: SKTexture, health: Int, attack: Int, speed: CGFloat, size: CGSize) {
=======

    init(texture: SKTexture, health: Int, attack: Int, speed: CGFloat) {
>>>>>>> 3945be4a506dd920c41be00a776492f0ee812118
        self.health = health
        self.attack = attack
        super.init(texture: texture, color: .clear, size: size)
        self.speed = speed
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(deltaTime: TimeInterval) {
        // Override in subclasses
    }

    func takeDamage(_ damage: Int) {
        health -= damage
        if health <= 0 {
            removeFromParent()
        }
    }
}
