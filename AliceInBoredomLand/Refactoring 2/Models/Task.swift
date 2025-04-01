//
//  Task.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

class Task {
    var availableFrames = 14
    var speed: CGFloat = -100
    var posX: CGFloat
    var posY: CGFloat

    var size: CGSize
    var physicsEntity: PhysicsEntity


    init(posX: CGFloat, posY: CGFloat, size: CGSize) {
        self.posX = posX
        self.posY = posY
        self.size = size
        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: 0, velocityY: speed,
                                           width: size.width, height: size.height,
                                           entityCategories: PhysicsBitMask.none, collidesWith: PhysicsBitMask.none)
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

    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = self.scene as? GameScene,
        let logic = scene.gameLogicDelegate as? GameLogic {
            logic.increaseMana(by: 10)
        }
        removeFromParent()
    }
     */
}
