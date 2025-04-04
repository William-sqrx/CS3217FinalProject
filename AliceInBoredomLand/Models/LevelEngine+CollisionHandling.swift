//
//  LevelEngineImpl+CollisionHandling.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

extension LevelEngine {
    func handleEvents(events: [PhysicsEvent]) {
        for event in events {
            if let (entityA, entityB) = getAttackerAndDefender(from: event.entityA, and: event.entityB) {
                processEntityHitType(attackerEntity: entityA, defenderEntity: entityB)
            }
        }
    }

    private func getAttackerAndDefender(from bodyA: PhysicsEntity, and bodyB: PhysicsEntity)
    -> (attacker: LevelEntity, defender: LevelEntity)? {
        guard let entityA = hitboxLevelEntitySynchronizer.getOuterElement(innerElement: bodyA),
              let entityB = hitboxLevelEntitySynchronizer.getOuterElement(innerElement: bodyB) else {
            return nil
        }
        if abs(bodyA.velocityX) > abs(bodyB.velocityX) {
            return (entityA, entityB)
        } else {
            return (entityB, entityA)
        }
    }

    private func applyKnockback(to entity: LevelEntity, speed: CGFloat) {
        var temp = entity.physicsEntity
        temp.velocityX = speed
        temp.velocityY = 0

        physicsEngine.replaceEntity(entity.physicsEntity, with: temp)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var final = temp
            final.velocityX = 0
            final.velocityY = 0
            self.physicsEngine.replaceEntity(temp, with: final)
        }
    }

    private func processEntityHitType(attackerEntity: LevelEntity, defenderEntity: LevelEntity) {
        let knockbackSpeed: CGFloat = 0

        switch (attackerEntity, defenderEntity) {

        case (let hero as Hero, var monster as Monster):
            print("Hero attacked Monster!")
            monster.takeDamage(hero.attack)
            applyKnockback(to: monster, speed: knockbackSpeed)

        case (let monster as Monster, var hero as Hero):
            print("Monster attacked Hero!")
            hero.takeDamage(monster.attack)
            applyKnockback(to: hero, speed: -knockbackSpeed)

        case (let hero as Hero, var castle as Castle):
            guard !castle.isPlayer else {
                return
            }
            print("Hero attacked Enemy Castle!")
            castle.takeDamage(hero.attack)
            levelLogicDelegate.decreMonsterCastleHealth(amount: hero.attack)
            applyKnockback(to: hero, speed: knockbackSpeed)

        case (let monster as Monster, var castle as Castle):
            guard castle.isPlayer else {
                return
            }
            print("Monster attacked Player Castle!")
            castle.takeDamage(monster.attack)
            levelLogicDelegate.decrePlayerCastleHealth(amount: monster.attack)
            applyKnockback(to: monster, speed: -knockbackSpeed)

        default:
            break
        }
    }
}

/*
private func handleArrowVsMonster(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) -> Bool {
    if let arrow = bodyA.node as? Arrow,
       let monster = bodyB.node?.userData?["entity"] as? Monster {
        handleArrowHit(arrow: arrow, monster: monster)
        return true
    }

    if let monster = bodyA.node?.userData?["entity"] as? Monster,
       let arrow = bodyB.node as? Arrow {
        handleArrowHit(arrow: arrow, monster: monster)
        return true
    }

    return false
}

private func handleArrowVsCastle(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) -> Bool {
    if let arrow = bodyA.node as? Arrow,
       let castle = bodyB.node?.userData?["entity"] as? LevelCastle {
        handleArrowCastleHit(arrow: arrow, castle: castle)
        return true
    }

    if let castle = bodyA.node?.userData?["entity"] as? LevelCastle,
       let arrow = bodyB.node as? Arrow {
        handleArrowCastleHit(arrow: arrow, castle: castle)
        return true
    }

    return false
}

private func handleArrowHit(arrow: Arrow, monster: Monster) {
    monster.takeDamage(arrow.damage)
    arrow.removeFromParent()
}

private func handleArrowCastleHit(arrow: Arrow, castle: LevelCastle) {
    castle.takeDamage(arrow.damage)
    levelLogicDelegate.decreMonsterCastleHealth(amount: arrow.damage)
    arrow.removeFromParent()
}
*/
