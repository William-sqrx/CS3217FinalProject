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

        if let arrow = bodyA.node as? Arrow, let monster = bodyB.node?.userData?["entity"] as? Monster {
            handleArrowHit(arrow: arrow, monster: monster)
            return
        } else if let monster = bodyA.node?.userData?["entity"] as? Monster, let arrow = bodyB.node as? Arrow {
            handleArrowHit(arrow: arrow, monster: monster)
            return
        }

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
            print("Hero attacked Monster!")
            monster.takeDamage(hero.attack)

            applyKnockback(to: monster, speed: knockbackSpeed)
        } else if let monster = attackerEntity as? Monster, let hero = defenderEntity as? Hero {
            print("Monster attacked Hero!")
            hero.takeDamage(monster.attack)

            applyKnockback(to: hero, speed: -knockbackSpeed)
        }
    }

    private func handleArrowHit(arrow: Arrow, monster: Monster) {
        print("Arrow hit Monster!")
        monster.takeDamage(arrow.damage)
        arrow.removeFromParent()
    }

    private func applyKnockback(to entity: GameEntity, speed: CGFloat) {
        guard let node = entity as? EntityNode else { return }
        node.physicsBody?.velocity = CGVector(dx: speed, dy: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            node.physicsBody?.velocity = .zero
        }
    }
}
