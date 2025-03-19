//
//  GameScene+Collisions.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }

        // Check if a Hero collides with a Monster using bitwise AND (`&`)
        if (contactA.categoryBitMask & (BitMask.Hero.tanker | BitMask.Hero.swordsman | BitMask.Hero.archer)) != 0 &&
           (contactB.categoryBitMask & (BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage)) != 0 {
            // gonna do something
        }

        // Check if a Monster collides with a Hero
        if (contactA.categoryBitMask & (BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage)) != 0 &&
           (contactB.categoryBitMask & (BitMask.Hero.tanker | BitMask.Hero.swordsman | BitMask.Hero.archer)) != 0 {
            // gonna do somethin
        }
    }
}
