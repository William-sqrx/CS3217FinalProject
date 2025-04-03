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

    private var physicsArraySynchronizer: ArraySynchronizer<SKSpriteNode, PhysicsEntity> = ArraySynchronizer()
    private var physicsScene: SKScene
    private var renderer: SKView

    func update(dt: TimeInterval) -> [PhysicsEvent] {
        print(physicsArraySynchronizer)
        physicsArraySynchronizer.clearAll()
        for node in physicsScene.children {
            if let node = node as? SKSpriteNode, let physicsEntity = convertToExternalType(node) {
                physicsArraySynchronizer.add(innerElement: node, outerElement: physicsEntity)
            }
        }

        return physicsEvents
    }

    func addEntity(_ entity: PhysicsEntity) {
        let node = convertToInternalType(entity)
        physicsArraySynchronizer.add(innerElement: node, outerElement: entity)
        physicsScene.addChild(node)
    }

    func removeEntity(_ entity: PhysicsEntity) {
        if let node = physicsArraySynchronizer.getInnerElement(outerElement: entity) {
            node.removeFromParent()
            physicsArraySynchronizer.removeInnerElement(node)
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
        renderer = SKView(frame: CGRect(origin: .zero, size: boundarySize))
        renderer.presentScene(physicsScene)
        super.init()

        physicsScene.physicsWorld.contactDelegate = self
    }

    func clearAll() {
        physicsScene.removeAllChildren()
        physicsArraySynchronizer.clearAll()
    }

    private func convertToInternalType(_ entity: PhysicsEntity) -> SKSpriteNode {
        let node = SKSpriteNode(texture: nil, size: CGSize(width: entity.width, height: entity.height))

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

        node.name = entity.id.uuidString
        node.physicsBody = physicsBody
        node.position.x = entity.x
        node.position.y = entity.y
        return node
    }

    private func convertToExternalType(_ node: SKSpriteNode) -> PhysicsEntity? {
        if let physicsBody = node.physicsBody {
            var result = PhysicsEntity(x: node.position.x, y: node.position.y,
                                       velocityX: physicsBody.velocity.dx, velocityY: physicsBody.velocity.dy,
                                       width: node.size.width, height: node.size.height,
                                       entityCategories: PhysicsBitMask(physicsBody.categoryBitMask),
                                       collidesWith: PhysicsBitMask(physicsBody.collisionBitMask),
                                       notifiesCollisionsWith: PhysicsBitMask(physicsBody.contactTestBitMask),
                                       affectsSelfOnCollision: !physicsBody.isDynamic,
                                       affectsOthersOnCollision: physicsBody.mass != 0)
            if let name = node.name, let id = UUID(uuidString: name) {
                result.id = id
            }
            return result
        }
        return nil
    }
}

extension PhysicsEngine: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? SKSpriteNode,
              let nodeB = contact.bodyB.node as? SKSpriteNode else {
            return
        }
        guard let bodyA = physicsArraySynchronizer.getOuterElement(innerElement: nodeA),
              let bodyB = physicsArraySynchronizer.getOuterElement(innerElement: nodeB) else {
            return
        }
        physicsEvents.append(PhysicsEvent(entityA: bodyA, entityB: bodyB))
    }

    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? SKSpriteNode,
              let nodeB = contact.bodyB.node as? SKSpriteNode else {
            return
        }
        guard let bodyA = physicsArraySynchronizer.getOuterElement(innerElement: nodeA),
              let bodyB = physicsArraySynchronizer.getOuterElement(innerElement: nodeB) else {
            return
        }
        physicsEvents.removeAll(where: { $0.entityA == bodyA && $0.entityB == bodyB })
        physicsEvents.removeAll(where: { $0.entityA == bodyB && $0.entityB == bodyA })
    }
}
