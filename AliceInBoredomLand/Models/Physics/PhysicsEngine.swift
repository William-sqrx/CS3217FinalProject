//
//  PhysicsEngine.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation
import SpriteKit

class PhysicsEngine: NSObject, PhysicsEngineFacade {
    var boundarySize: CGSize
    var physicsBodies: [PhysicsEntity] {
        physicsArraySynchronizer.getOuterArray()
    }
    var physicsEvents: [PhysicsEvent] = []

    private var physicsArraySynchronizer: ArraySynchronizer<SKPhysicsBody, PhysicsEntity> = ArraySynchronizer()
    private var physicsScene: SKScene

    func update(dt: TimeInterval) -> [PhysicsEvent] {
        physicsScene.update(dt)
        return physicsEvents
    }

    func addEntity(_ entity: PhysicsEntity) {
        let node = SKNode()
        node.physicsBody = convertToInternalType(entity)
        if let physicsBody = node.physicsBody {
            physicsArraySynchronizer.add(innerElement: physicsBody, outerElement: entity)
            physicsScene.addChild(node)
        }
    }

    func removeEntity(_ entity: PhysicsEntity) {
        if let internalEntity = physicsArraySynchronizer.getInnerElement(outerElement: entity) {
            internalEntity.node?.removeFromParent()
            physicsArraySynchronizer.removeInnerElement(internalEntity)
        }
    }

    // Assumes entity already exists in the engine
    func replaceEntity(_ oldEntity: PhysicsEntity, with newEntity: PhysicsEntity) {
        removeEntity(oldEntity)
        addEntity(newEntity)
    }

    init(boundarySize: CGSize) {
        self.boundarySize = boundarySize
        physicsScene = SKScene(size: boundarySize)
        super.init()

        physicsScene.isPaused = true
        physicsScene.physicsWorld.contactDelegate = self
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
}

extension PhysicsEngine: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let bodyA = physicsArraySynchronizer.getOuterElement(innerElement: contact.bodyA),
           let bodyB = physicsArraySynchronizer.getOuterElement(innerElement: contact.bodyB) {
            physicsEvents.append(PhysicsEvent(entityA: bodyA, entityB: bodyB))
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if let bodyA = physicsArraySynchronizer.getOuterElement(innerElement: contact.bodyA),
           let bodyB = physicsArraySynchronizer.getOuterElement(innerElement: contact.bodyB) {
            physicsEvents.removeAll(where: { $0.entityA == bodyA && $0.entityB == bodyB })
            physicsEvents.removeAll(where: { $0.entityA == bodyB && $0.entityB == bodyA })
        }
    }
}
