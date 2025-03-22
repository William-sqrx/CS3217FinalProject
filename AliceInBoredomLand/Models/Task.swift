//
//  Task.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation
import SpriteKit

class Task: SKSpriteNode {

    var availableFrames = 20

    var node: SKSpriteNode {
        self
    }

    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(deltaTime: TimeInterval) {
        if availableFrames < 0 {
            removeFromParent()
        }

        if node.position.x < size.width / 2 {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        } else {
            self.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        }
        availableFrames -= 1
    }

}
