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

        if handleTaskCollision(bodyA: bodyA, bodyB: bodyB) {
            return
        }
        if handleArrowVsMonster(bodyA: bodyA, bodyB: bodyB) {
            return
        }
        if handleArrowVsCastle(bodyA: bodyA, bodyB: bodyB) {
            return
        }

        if let (attacker, defender) = getAttackerAndDefender(from: bodyA, and: bodyB) {
            checkEntityHitType(attackerEntity: attacker, defenderEntity: defender)
        }
    }

    private func getAttackerAndDefender(from bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody)
    -> (attacker: OldGameEntity, defender: OldGameEntity)? {
        let attackerBody: SKPhysicsBody
        let defenderBody: SKPhysicsBody

        if abs(bodyA.velocity.dx) > abs(bodyB.velocity.dx) {
            attackerBody = bodyA
            defenderBody = bodyB
        } else {
            attackerBody = bodyB
            defenderBody = bodyA
        }

        guard let attackerEntity = attackerBody.node?.userData?["entity"] as? OldGameEntity,
              let defenderEntity = defenderBody.node?.userData?["entity"] as? OldGameEntity else {
            return nil
        }

        return (attackerEntity, defenderEntity)
    }

    private func handleTaskCollision(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) -> Bool {
        guard let taskA = bodyA.node as? Task,
              let taskB = bodyB.node as? Task else { return false }

        let (left, right) = taskA.position.x < taskB.position.x ? (taskA, taskB) : (taskB, taskA)
        handleTaskHit(left: left, right: right)
        return true
    }

    private func handleArrowVsMonster(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) -> Bool {
        if let arrow = bodyA.node as? Arrow,
           let monster = bodyB.node?.userData?["entity"] as? OldMonster {
            handleArrowHit(arrow: arrow, monster: monster)
            return true
        }

        if let monster = bodyA.node?.userData?["entity"] as? OldMonster,
           let arrow = bodyB.node as? Arrow {
            handleArrowHit(arrow: arrow, monster: monster)
            return true
        }

        return false
    }

    private func handleArrowVsCastle(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) -> Bool {
        if let arrow = bodyA.node as? Arrow,
           let castle = bodyB.node?.userData?["entity"] as? OldGameCastle {
            handleArrowCastleHit(arrow: arrow, castle: castle)
            return true
        }

        if let castle = bodyA.node?.userData?["entity"] as? OldGameCastle,
           let arrow = bodyB.node as? Arrow {
            handleArrowCastleHit(arrow: arrow, castle: castle)
            return true
        }

        return false
    }

    private func handleArrowHit(arrow: Arrow, monster: OldMonster) {
        monster.takeDamage(arrow.damage)
        monster.physicsBody?.velocity = CGVector(dx: monster.speed * -1, dy: 0)
        monster.zRotation = 0
        monster.physicsBody?.angularVelocity = 0
        arrow.removeFromParent()
    }

    private func handleArrowCastleHit(arrow: Arrow, castle: OldGameCastle) {
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

    private func checkEntityHitType(attackerEntity: OldGameEntity, defenderEntity: OldGameEntity) {
        let knockbackSpeed: CGFloat = 0

        switch (attackerEntity, defenderEntity) {

        case let (hero as OldHero, monster as OldMonster):
            print("Hero attacked Monster!")
            monster.takeDamage(hero.attack)
            applyKnockback(to: monster, speed: knockbackSpeed)

        case let (monster as OldMonster, hero as OldHero):
            print("Monster attacked Hero!")
            hero.takeDamage(monster.attack)
            applyKnockback(to: hero, speed: -knockbackSpeed)

        case let (hero as OldHero, castle as OldGameCastle):
            guard !castle.isPlayer else {
                return
            }
            print("Hero attacked Enemy Castle!")
            castle.takeDamage(hero.attack)
            gameLogicDelegate.decreMonsterCastleHealth(amount: hero.attack)
            applyKnockback(to: hero, speed: knockbackSpeed)

        case let (monster as OldMonster, castle as OldGameCastle):
            guard castle.isPlayer else {
                return
            }
            print("Monster attacked Player Castle!")
            castle.takeDamage(monster.attack)
            gameLogicDelegate.decrePlayerCastleHealth(amount: monster.attack)
            applyKnockback(to: monster, speed: -knockbackSpeed)

        default:
            break
        }
    }

    private func applyKnockback(to entity: OldGameEntity, speed: CGFloat) {
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
