//
//  PhysicsAdapter.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

final class PhysicsAdapter {
    static func makeBody(from provider: PhysicsBodySpecProvider) -> SKPhysicsBody {
        let component = provider.physicsBodySpec
        let body = SKPhysicsBody(rectangleOf: component.size)
        body.isDynamic = component.isDynamic
        body.categoryBitMask = component.categoryBitMask
        body.contactTestBitMask = component.contactTestBitMask
        body.collisionBitMask = component.collisionBitMask
        body.affectedByGravity = false
        body.allowsRotation = false
        return body
    }
}
