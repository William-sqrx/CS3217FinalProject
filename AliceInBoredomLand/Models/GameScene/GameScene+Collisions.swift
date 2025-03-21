//
//  GameScene+Collisions.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        /*
        if let arrow = bodyA.node as? Arrow, let monster = bodyB.node?.userData?["entity"] as? Monster {
            handleArrowHit(arrow: arrow, monster: monster)
            return
        } else if let monster = bodyA.node?.userData?["entity"] as? Monster, let arrow = bodyB.node as? Arrow {
            handleArrowHit(arrow: arrow, monster: monster)
            return
        }
         */

        var attackerBody: SKPhysicsBody
        var defenderBody: SKPhysicsBody

        if abs(bodyA.velocity.dx) > abs(bodyB.velocity.dx) {
            attackerBody = bodyA
            defenderBody = bodyB
        } else {
            attackerBody = bodyB
            defenderBody = bodyA
        }

        guard let attackerEntity = attackerBody.node?.userData?["entity"] as? GameEntity,
              let defenderEntity = defenderBody.node?.userData?["entity"] as? GameEntity else {
            print("Error: Missing entity reference in userData")
            return
        }

        let knockbackSpeed: CGFloat = 10

        if let hero = attackerEntity as? Hero, let monster = defenderEntity as? Monster {
            print("Hero collided with Monster!")
            entityCollisions.append((hero.id, monster.id))
            applyKnockback(to: monster, speed: knockbackSpeed)
        } else if let monster = attackerEntity as? Monster, let hero = defenderEntity as? Hero {
            print("Monster collided with Hero!")
            entityCollisions.append((monster.id, hero.id))
            applyKnockback(to: hero, speed: -knockbackSpeed)
        }
        notifySubscribers()
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        guard let entityA = bodyA.node?.userData?["entity"] as? GameEntity,
              let entityB = bodyB.node?.userData?["entity"] as? GameEntity else {
            print("Error: Missing entity reference in userData")
            return
        }
        entityCollisions.removeAll(where: { $0 == (entityA.id, entityB.id) })
        entityCollisions.removeAll(where: { $0 == (entityB.id, entityA.id) })
    }

    /*private func handleArrowHit(arrow: Arrow, monster: Monster) {
        print("Arrow hit Monster!")
        monster.takeDamage(arrow.damage)
        arrow.removeFromParent()
    }*/

    private func applyKnockback(to entity: GameEntity, speed: CGFloat) {
        entity.physicsBody?.velocity = CGVector(dx: speed, dy: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            entity.physicsBody?.velocity = .zero
        }
    }
}
