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

        var attackerBody: SKPhysicsBody
        var defenderBody: SKPhysicsBody

        if let taskA = bodyA.node as? Task, let taskB = bodyB.node as? Task {
            if taskA.position.x < taskB.position.x {
                handleTaskHit(left: taskA, right: taskB)
            } else {
                handleTaskHit(left: taskB, right: taskA)
            }
        }

        if abs(bodyA.velocity.dx) > abs(bodyB.velocity.dx) {
            attackerBody = bodyA
            defenderBody = bodyB
        } else {
            attackerBody = bodyB
            defenderBody = bodyA
        }

        if let arrow = bodyA.node as? Arrow, let monster = bodyB.node?.userData?["entity"] as? Monster {
            handleArrowHit(arrow: arrow, monster: monster)
            return
        } else if let monster = bodyA.node?.userData?["entity"] as? Monster, let arrow = bodyB.node as? Arrow {
            handleArrowHit(arrow: arrow, monster: monster)
            return
        }

        if let arrow = bodyA.node as? Arrow, let castle = bodyB.node?.userData?["entity"] as? GameCastle {
            handleArrowCastleHit(arrow: arrow, castle: castle)
            return
        } else if let castle = bodyA.node?.userData?["entity"] as? GameCastle, let arrow = bodyB.node as? Arrow {
            handleArrowCastleHit(arrow: arrow, castle: castle)
            return
        }

        guard let attackerEntity = attackerBody.node?.userData?["entity"] as? GameEntity,
              let defenderEntity = defenderBody.node?.userData?["entity"] as? GameEntity else {
            print("Error: Missing entity reference in userData")
            return
        }

        checkEntityHitType(attackerEntity: attackerEntity, defenderEntity: defenderEntity)
    }

    private func handleArrowHit(arrow: Arrow, monster: Monster) {
        print("Arrow hit Monster!")
        monster.takeDamage(arrow.damage)
        monster.physicsBody?.velocity = CGVector(dx: monster.speed * -1, dy: 0)
        monster.zRotation = 0
        monster.physicsBody?.angularVelocity = 0
        arrow.removeFromParent()
    }

    private func handleArrowCastleHit(arrow: Arrow, castle: GameCastle) {
        print("Arrow hit Castle!")
        castle.takeDamage(arrow.damage)
        gameLogicDelegate.decreMonsterCastleHealth(amount: arrow.damage)
        arrow.removeFromParent()
    }

    private func handleTaskHit(left: Task, right: Task) {
        right.physicsBody?.velocity = .zero
        left.physicsBody?.velocity = .zero

        left.physicsBody?.isDynamic = false
        right.physicsBody?.isDynamic = false
    }

    private func checkEntityHitType(attackerEntity: GameEntity, defenderEntity: GameEntity) {
        let knockbackSpeed: CGFloat = 0

        if let hero = attackerEntity as? Hero, let monster = defenderEntity as? Monster {
            print("Hero attacked Monster!")
            monster.takeDamage(hero.attack)

            applyKnockback(to: monster, speed: knockbackSpeed)
        } else if let monster = attackerEntity as? Monster, let hero = defenderEntity as? Hero {
            print("Monster attacked Hero!")
            hero.takeDamage(monster.attack)

            applyKnockback(to: hero, speed: -knockbackSpeed)
        }

        if let monster = attackerEntity as? Monster, let castle = defenderEntity as? GameCastle {
            print("Monster attacked Castle!")
            castle.takeDamage(monster.attack)
            gameLogicDelegate.decrePlayerCastleHealth(amount: monster.attack)

            applyKnockback(to: monster, speed: knockbackSpeed)
        }
    }

    private func applyKnockback(to entity: GameEntity, speed: CGFloat) {
        guard let node = entity as? EntityNode else {
            return
        }
        let originalY = node.position.y
        node.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        node.physicsBody?.angularVelocity = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            node.physicsBody?.velocity = .zero
            node.physicsBody?.angularVelocity = 0
            node.position.y = originalY
        }
    }
}
