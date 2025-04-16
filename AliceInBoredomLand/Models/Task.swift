//
//  Task.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation
import SpriteKit

class Task: GameEntity {
    var availableFrames = 14

    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.task,
            contactTestBitMask: BitMask.task,
            collisionBitMask: BitMask.task
        )
        super.init(textureName: "task", size: size, position: position, health: 1, attack: 0,
                   moveSpeed: -100, physics: physics)
        self.name = "task"
        self.velocity = CGVector(dx: moveSpeed, dy: 0)
        self.isUserInteractionEnabled = true
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        if availableFrames < 0 {
            removeFromParent()
        }
        availableFrames -= 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = self.scene as? LevelScene,
           let logic = scene.gameLogicDelegate as? LevelLogic {
            logic.increaseMana(by: 10)
        }
        removeFromParent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
