//
//  Task.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation
import SpriteKit

class Task: LevelEntity {
    var availableFrames = 14

    init(position: CGPoint, size: CGSize) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.task,
            contactTestBitMask: BitMask.task,
            collisionBitMask: BitMask.task
        )
        super.init(textureName: "task", size: size, position: position, health: 1, attack: 0, moveSpeed: -100, physics: physics)

        renderNode.name = "task"
        renderNode.setUserInteraction(enabled: true)
        renderNode.setOnTouch { [weak self] in
            guard let self = self else { return }
            if let scene = self.renderNode as? SpriteKitRenderNode,
               let skScene = scene.spriteNode.scene as? SKScene,
               let levelScene = skScene as? LevelScene,
               let logic = levelScene.gameLogicDelegate as? LevelLogic {
                logic.increaseMana(by: 10)
            }
            self.renderNode.removeFromScene()
        }
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        renderNode.velocity = CGVector(dx: moveSpeed, dy: 0)
        if availableFrames < 0 {
            renderNode.removeFromScene()
        }
        availableFrames -= 1
    }
}
