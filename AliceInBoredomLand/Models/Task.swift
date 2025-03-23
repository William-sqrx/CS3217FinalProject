//
//  Task.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation
import SpriteKit

class Task: SKSpriteNode {

    var availableFrames = 14

    var node: SKSpriteNode {
        self
    }

    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)
        self.isUserInteractionEnabled = true

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = BitMask.Task.task
        self.physicsBody?.collisionBitMask = BitMask.Task.task
        self.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(deltaTime: TimeInterval) {
        if availableFrames < 0 {
            removeFromParent()
        }

        if node.position.x < size.width {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        } else {
            self.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        }
        availableFrames -= 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = self.scene as? GameScene,
        let logic = scene.gameLogicDelegate as? GameLogic {
            logic.increaseMana(by: 10)
        }
        removeFromParent()
    }
}
