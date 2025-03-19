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
    var node: SKSpriteNode { return self }
    override var speed: CGFloat {
        set { super.speed = newValue }
        get { return super.speed }
    }
    
    var isAlive: Bool { health > 0 }
    
    init(texture: SKTexture, health: Int, attack: Int, speed: CGFloat) {
        self.health = health
        self.attack = attack
        super.init(texture: texture, color: .clear, size: texture.size())
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
