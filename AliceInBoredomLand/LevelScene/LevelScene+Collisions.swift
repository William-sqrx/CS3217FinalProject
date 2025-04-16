////
////  LevelScene+Collisions.swift
////  AliceInBoredomLand
////
////  Created by Wijaya William on 18/3/25.
////
//
//import SpriteKit
//
//extension LevelScene: SKPhysicsContactDelegate {
//    func didBegin(_ contact: SKPhysicsContact) {
//        guard
//            let nodeA = contact.bodyA.node as? GameEntity,
//            let nodeB = contact.bodyB.node as? GameEntity
//        else { return }
//
//        let names = [nodeA.name, nodeB.name]
//
//        // 🧟 Monster hits player castle
//        if names.contains("monster") && names.contains("player-castle") {
//            print("✅ Monster collided with player castle")
//            if let castle = [nodeA, nodeB].first(where: { $0.name == "player-castle" }) {
//                ActionPerformer.perform(DamageAction(amount: 1000), on: castle)
//                if let logic = gameLogicDelegate as? LevelLogic {
//                    logic.playerCastleHealth -= 1000
//                }
//            }
//        }
//
//        // 🛡️ Hero hits monster castle
//        if names.contains("hero") && names.contains("monster-castle") {
//            print("✅ Hero collided with monster castle")
//            if let castle = [nodeA, nodeB].first(where: { $0.name == "monster-castle" }) {
//                ActionPerformer.perform(DamageAction(amount: 10), on: castle)
//                if let logic = gameLogicDelegate as? LevelLogic {
//                    logic.monsterCastleHealth -= 10
//                }
//            }
//        }
//
//        // ⚔️ Monster collides with hero
//        if let monster = [nodeA, nodeB].first(where: { $0.name == "monster" }) as? GameEntity,
//           let hero = [nodeA, nodeB].first(where: { $0.name == "hero" }) as? GameEntity {
//            print("✅ Monster collided with hero")
//            ActionPerformer.perform(KnockbackAction(direction: CGVector(dx: 1, dy: 0), duration: 0.2, speed: 30), on: monster)
//            ActionPerformer.perform(KnockbackAction(direction: CGVector(dx: -1, dy: 0), duration: 0.2, speed: 30), on: hero)
//
//            ActionPerformer.perform(DamageAction(amount: monster.attack), on: hero)
//            ActionPerformer.perform(DamageAction(amount: hero.attack), on: monster)
//        }
//    }
//}
