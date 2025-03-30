//
//  PhysicsEntityImpl.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation
import SpriteKit

struct PhysicsEntityImpl: PhysicsEntity {
    var x: Double
    var y: Double
    var velocityX: Double
    var velocityY: Double
    var width: Double
    var height: Double

    var entityCategories: PhysicsBitMask
    var collidesWith: PhysicsBitMask
    var notifiesCollisionsWith: PhysicsBitMask
    var affectsSelfOnCollision: Bool
    var affectsOthersOnCollision: Bool

    var physicsBody: SKPhysicsBody

    init(x: Double, y: Double, velocityX: Double, velocityY: Double, width: Double, height: Double,
         entityCategories: PhysicsBitMask, collidesWith: PhysicsBitMask, notifiesCollisionsWith: PhysicsBitMask,
         affectsSelfOnCollision: Bool = true, affectsOthersOnCollision: Bool = true) {
        self.x = x
        self.y = y
        self.velocityX = velocityX
        self.velocityY = velocityY
        self.width = width
        self.height = height

        self.entityCategories = entityCategories
        self.collidesWith = collidesWith
        self.notifiesCollisionsWith = notifiesCollisionsWith
        self.affectsSelfOnCollision = affectsSelfOnCollision
        self.affectsOthersOnCollision = affectsOthersOnCollision

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height),
                                    center: CGPoint(x: x, y: y))

        physicsBody.velocity = CGVector(dx: CGFloat(velocityX), dy: CGFloat(velocityY))
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = entityCategories.getBitMask()
        physicsBody.collisionBitMask = collidesWith.getBitMask()
        physicsBody.contactTestBitMask = notifiesCollisionsWith.getBitMask()
        if !affectsSelfOnCollision {
            physicsBody.isDynamic = false
        } else {
            physicsBody.isDynamic = true
        }
        // Ensures applied impulses does not affect other objects, but may have strange interactions with physics fields
        if !affectsOthersOnCollision {
            physicsBody.mass = 0
        }
    }

    func getPhysicsBody() -> SKPhysicsBody {
        return physicsBody
    }
    mutating func setPhysicsBody(_ physicsBody: SKPhysicsBody) {
        self.physicsBody = physicsBody
    }
}
