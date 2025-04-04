//
//  Task.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

class Task {
    var availableFrames = 14
    var speed: CGFloat = 0
    var posX: CGFloat {
        get {
            physicsEntity.x
        }
        set {
            physicsEntity.x = newValue
        }
    }
    var posY: CGFloat {
        get {
            physicsEntity.x
        }
        set {
            physicsEntity.x = newValue
        }
    }

    var size: CGSize
    var physicsEntity: PhysicsEntity

    init(posX: CGFloat, posY: CGFloat, size: CGSize) {
        self.size = size

        self.physicsEntity = PhysicsEntity(x: posX, y: posY, velocityX: -speed, velocityY: 0,
                                           width: size.width, height: size.height,
                                           entityCategories: PhysicsBitMask(PhysicsBitMask.none),
                                           collidesWith: PhysicsBitMask(PhysicsBitMask.none))
        // print(physicsEntity.id)
    }

    func update(dt: TimeInterval) {
        physicsEntity.velocityX = -speed
        physicsEntity.velocityY = 0
        availableFrames -= 1
    }

    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = self.scene as? LevelScene,
        let logic = scene.levelLogicDelegate as? LevelLogic {
            logic.increaseMana(by: 10)
        }
        removeFromParent()
    }
     */
}
