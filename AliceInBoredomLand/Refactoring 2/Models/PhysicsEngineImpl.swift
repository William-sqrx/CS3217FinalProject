//
//  PhysicsEngineImpl.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation
import SpriteKit

struct PhysicsEngineImpl: PhysicsEngine {
    var boundarySize: CGSize
    var physicsScene: SKScene
    var physicsBodies: [SKPhysicsBody] = []

    func update(dt: TimeInterval) -> [any PhysicsEvent] {
        physicsScene.update(dt)
        return []
    }

    mutating func addEntity(_ entity: PhysicsEntity) {
        let node = SKNode()
        node.physicsBody = processEntity(entity)
        if let physicsBody = node.physicsBody {
            physicsBodies.append(physicsBody)
            physicsScene.addChild(node)
        }
    }

    mutating func removeEntity(_ entity: PhysicsEntity) {
        let temp = processEntity(entity)
        for idx in physicsBodies.indices where physicsBodies[idx] == temp {
            physicsBodies[idx].node?.removeFromParent()
        }
        physicsBodies.removeAll(where: { $0 == temp })

    }

    init(boundarySize: CGSize) {
        self.boundarySize = boundarySize
        physicsScene = SKScene(size: boundarySize)
    }

    private func processEntity(_ entity: PhysicsEntity) -> SKPhysicsBody {
        var physicsBody: SKPhysicsBody

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: entity.width, height: entity.height),
                                    center: CGPoint(x: entity.x, y: entity.y))

        physicsBody.velocity = CGVector(dx: CGFloat(entity.velocityX), dy: CGFloat(entity.velocityY))
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = entity.entityCategories.getBitMask()
        physicsBody.collisionBitMask = entity.collidesWith.getBitMask()
        physicsBody.contactTestBitMask = entity.notifiesCollisionsWith.getBitMask()
        if !entity.affectsSelfOnCollision {
            physicsBody.isDynamic = false
        } else {
            physicsBody.isDynamic = true
        }
        // Ensures applied impulses does not affect other objects, but may have strange interactions with physics fields
        if !entity.affectsOthersOnCollision {
            physicsBody.mass = 0
        }

        return physicsBody
    }
}
