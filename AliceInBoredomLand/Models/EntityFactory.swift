//
//  EntityFactory.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

final class EntityFactory {

    static func makeHero(type: HeroType, position: CGPoint, size: CGSize) -> (model: OldHeroModel, node: SKSpriteNode) {
        let stats: HeroStats = {
            switch type {
            case .archer:
                return HeroStats(manaCost: 10, attack: 2, health: 90, speed: 25, bitmask: OldBitMask.Hero.archer)
            case .swordsman:
                return HeroStats(manaCost: 15, attack: 50, health: 100, speed: 20, bitmask: OldBitMask.Hero.swordsman)
            case .tank:
                return HeroStats(manaCost: 20, attack: 2, health: 200, speed: 20, bitmask: OldBitMask.Hero.tank)
            }
        }()

        let physics = OldPhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: stats.bitmask,
            contactTestBitMask: OldBitMask.Monster.titan | OldBitMask.Monster.minion | OldBitMask.Monster.mage | OldBitMask.Castle.enemyCastle,
            collisionBitMask: OldBitMask.Monster.titan | OldBitMask.Monster.minion | OldBitMask.Monster.mage | OldBitMask.Castle.enemyCastle
        )

        let model = OldHeroModel(
            position: position,
            health: stats.health,
            attack: stats.attack,
            speed: stats.speed,
            manaCost: stats.manaCost,
            physics: physics,
            type: type
        )

        let node = HeroRenderer.makeNode(from: model)
        node.name = "hero"
        return (model, node)
    }

    static func makeMonster(position: CGPoint, size: CGSize) -> (model: OldMonsterModel, node: SKSpriteNode) {
        let physics = OldPhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: OldBitMask.Monster.titan,
            contactTestBitMask: OldBitMask.Castle.playerCastle
                | OldBitMask.Hero.swordsman
                | OldBitMask.Hero.archer
                | OldBitMask.Hero.tank,
            collisionBitMask: OldBitMask.Castle.playerCastle
                | OldBitMask.Hero.swordsman
                | OldBitMask.Hero.archer
                | OldBitMask.Hero.tank
        )

        let model = OldMonsterModel(
            position: position,
            health: 100,
            attack: 1000,
            speed: 20,
            physics: physics
        )

        let node = MonsterRenderer.makeNode(from: model)
        node.name = "monster"
        return (model, node)
    }

    static func makeCastle(position: CGPoint, size: CGSize, isPlayer: Bool) -> (model: OldGameCastleModel, node: SKSpriteNode) {
        let physics = OldPhysicsComponent(
            size: size,
            isDynamic: false,
            categoryBitMask: isPlayer ? OldBitMask.Castle.playerCastle : OldBitMask.Castle.enemyCastle,
            contactTestBitMask: isPlayer
                ? OldBitMask.Monster.titan | OldBitMask.Monster.minion | OldBitMask.Monster.mage
                : OldBitMask.Hero.archer | OldBitMask.Hero.swordsman | OldBitMask.Hero.tank,
            collisionBitMask: isPlayer
                ? OldBitMask.Monster.titan | OldBitMask.Monster.minion | OldBitMask.Monster.mage
                : OldBitMask.Hero.archer | OldBitMask.Hero.swordsman | OldBitMask.Hero.tank
        )

        let model = OldGameCastleModel(
            position: position,
            health: 500,
            isPlayer: isPlayer,
            physics: physics,
            textureName: isPlayer ? "player-castle" : "enemy-castle"
        )

        let node = isPlayer
            ? PlayerCastleRenderer.makeNode(from: model)
            : EnemyCastleRenderer.makeNode(from: model)
        return (model, node)
    }
    
    static func getHeroStats(type: HeroType) -> HeroStats {
        switch type {
        case .archer:
            return HeroStats(
                manaCost: 10,
                attack: 2,
                health: 90,
                speed: 25,
                bitmask: OldBitMask.Hero.archer
            )
        case .swordsman:
            return HeroStats(
                manaCost: 15,
                attack: 50,
                health: 100,
                speed: 20,
                bitmask: OldBitMask.Hero.swordsman
            )
        case .tank:
            return HeroStats(
                manaCost: 20,
                attack: 2,
                health: 200,
                speed: 20,
                bitmask: OldBitMask.Hero.tank
            )
        }
    }

    static func getMonsterStats() -> MonsterStats {
        MonsterStats(
            health: 100,
            attack: 900,
            speed: 20,
            bitmask: OldBitMask.Monster.titan
        )
    }
}
