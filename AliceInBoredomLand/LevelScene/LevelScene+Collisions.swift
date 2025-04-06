//
//  LevelScene+Collisions.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

extension LevelScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        let names = [nodeA?.name, nodeB?.name]

        // 🧟 Monster hits player castle
        if names.contains("monster") && names.contains("player-castle") {
            print("✅ Monster collided with player castle!!!")

            if let castleNode = [nodeA, nodeB].first(where: { $0?.name == "player-castle" }) as? SKSpriteNode {
                let damage = DamageCastleAction(amount: 1_000, isPlayerCastle: true)
                ActionPerformer.perform(damage, on: castleNode)
            }
        }

        // 🛡️ Hero hits monster castle
        if names.contains("hero") && names.contains("monster-castle") {
            print("✅ Hero collided with monster castle!")

            if let castleNode = [nodeA, nodeB].first(where: { $0?.name == "monster-castle" }) as? SKSpriteNode {
                let damage = DamageCastleAction(amount: 10, isPlayerCastle: false)
                ActionPerformer.perform(damage, on: castleNode)
            }
        }

        // ⚔️ Monster collides with hero
        if names.contains("monster") && names.contains("hero") {
            print("✅ Monster collided with hero!")

            guard
                let monsterNode = [nodeA, nodeB].first(where: { $0?.name == "monster" }) as? SKSpriteNode,
                let heroNode = [nodeA, nodeB].first(where: { $0?.name == "hero" }) as? SKSpriteNode,
                let monsterId = monsterNode.userData?["entityId"] as? UUID,
                let heroId = heroNode.userData?["entityId"] as? UUID,
                let monster = LevelModelRegistry.shared.getMonsterModel(id: monsterId),
                let hero = LevelModelRegistry.shared.getHeroModel(id: heroId)
            else { return }

            let knockbackMonster = KnockbackAction(direction: CGVector(dx: 1, dy: 0), duration: 0.2, speed: 30)
            let knockbackHero = KnockbackAction(direction: CGVector(dx: -1, dy: 0), duration: 0.2, speed: 30)

            ActionPerformer.perform(knockbackMonster, on: monsterNode)
            ActionPerformer.perform(knockbackHero, on: heroNode)

            let damageHero = DamageAction(amount: monster.attack)
            let damageMonster = DamageAction(amount: hero.attack)

            ActionPerformer.perform(damageHero, on: heroNode)
            ActionPerformer.perform(damageMonster, on: monsterNode)
        }
    }

    private func getAttackerAndDefender(from bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody)
    -> (attacker: LevelEntity, defender: LevelEntity)? {
        let attackerBody: SKPhysicsBody
        let defenderBody: SKPhysicsBody

        if abs(bodyA.velocity.dx) > abs(bodyB.velocity.dx) {
            attackerBody = bodyA
            defenderBody = bodyB
        } else {
            attackerBody = bodyB
            defenderBody = bodyA
        }

        guard let attackerEntity = attackerBody.node?.userData?["entity"] as? LevelEntity,
              let defenderEntity = defenderBody.node?.userData?["entity"] as? LevelEntity else {
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

    private func handleTaskHit(left: Task, right: Task) {
        right.physicsBody?.velocity = .zero
        left.physicsBody?.velocity = .zero

        left.physicsBody?.isDynamic = false
        right.physicsBody?.isDynamic = false
    }
}
