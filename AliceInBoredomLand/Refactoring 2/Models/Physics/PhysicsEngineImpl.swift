//
//  PhysicsEngineImpl.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation
import SpriteKit

class PhysicsEngineImpl: NSObject, PhysicsEngine {
    var boundarySize: CGSize
    var physicsBodies: [PhysicsEntity] = []
    var physicsEvents: [PhysicsEvent] = []

    private var physicsScene: SKScene
    private var internalBodies: [SKPhysicsBody] = []

    func update(dt: TimeInterval) -> [PhysicsEvent] {
        physicsScene.update(dt)
        return physicsEvents
    }

    func addEntity(_ entity: PhysicsEntity) {
        let node = SKNode()
        node.physicsBody = convertToInternalType(entity)
        if let physicsBody = node.physicsBody {
            physicsBodies.append(entity)
            internalBodies.append(physicsBody)
            physicsScene.addChild(node)
        }
    }

    func removeEntity(_ entity: PhysicsEntity) {
        let temp = convertToInternalType(entity)
        for idx in internalBodies.indices where internalBodies[idx] == temp {
            internalBodies[idx].node?.removeFromParent()
        }
        physicsBodies.removeAll(where: { $0 == entity })
        internalBodies.removeAll(where: { $0 == temp })
    }

    init(boundarySize: CGSize) {
        self.boundarySize = boundarySize
        physicsScene = SKScene(size: boundarySize)
    }

    private func convertToInternalType(_ entity: PhysicsEntity) -> SKPhysicsBody {
        var physicsBody: SKPhysicsBody

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: entity.width, height: entity.height),
                                    center: CGPoint(x: entity.x, y: entity.y))

        physicsBody.velocity = CGVector(dx: CGFloat(entity.velocityX), dy: CGFloat(entity.velocityY))
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = entity.entityCategories.bitMask
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

    private func getCorrespondingExternalEntity(_ physicsBody: SKPhysicsBody) -> PhysicsEntity? {
        for entity in physicsBodies where physicsBody == convertToInternalType(entity) {
            return entity
        }
        assert(false, "Could not find corresponding external representation to internal representation")
        return nil
    }
}

extension PhysicsEngineImpl: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let bodyA = getCorrespondingExternalEntity(contact.bodyA),
           let bodyB = getCorrespondingExternalEntity(contact.bodyB) {
            physicsEvents.append(PhysicsEvent(bodyA: bodyA, bodyB: bodyB))
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if let bodyA = getCorrespondingExternalEntity(contact.bodyA),
           let bodyB = getCorrespondingExternalEntity(contact.bodyB) {
            physicsEvents.removeAll(where: { $0.bodyA == bodyA && $0.bodyB == bodyB })
            physicsEvents.removeAll(where: { $0.bodyA == bodyB && $0.bodyB == bodyA })
        }
    }
}
