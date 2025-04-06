//
//  EntityFactory.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

final class EntityFactory {

    static func makeHero(type: HeroType, position: CGPoint, size: CGSize) -> (model: HeroModel, node: SKSpriteNode) {
        let stats: HeroStats = {
            switch type {
            case .archer:
                return HeroStats(manaCost: 10, attack: 2, health: 90, speed: 25, bitmask: BitMask.playerEntity)
            case .swordsman:
                return HeroStats(manaCost: 15, attack: 50, health: 100, speed: 20, bitmask: BitMask.playerEntity)
            case .tank:
                return HeroStats(manaCost: 20, attack: 2, health: 200, speed: 20, bitmask: BitMask.playerEntity)
            }
        }()

        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: stats.bitmask,
            contactTestBitMask: BitMask.enemyEntity,
            collisionBitMask: BitMask.enemyEntity
        )

        let model = HeroModel(
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

    static func makeMonster(position: CGPoint, size: CGSize) -> (model: MonsterModel, node: SKSpriteNode) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: true,
            categoryBitMask: BitMask.enemyEntity,
            contactTestBitMask: BitMask.playerEntity,
            collisionBitMask: BitMask.playerEntity
        )

        let model = MonsterModel(
            position: position,
            health: 100,
            attack: 1_000,
            speed: 20,
            physics: physics
        )

        let node = MonsterRenderer.makeNode(from: model)
        node.name = "monster"
        return (model, node)
    }

    static func makeCastle(position: CGPoint, size: CGSize, isPlayer: Bool)
    -> (model: LevelCastleModel, node: SKSpriteNode) {
        let physics = PhysicsComponent(
            size: size,
            isDynamic: false,
            categoryBitMask: isPlayer ? BitMask.playerEntity : BitMask.enemyEntity,
            contactTestBitMask: isPlayer
            ? BitMask.enemyEntity
            : BitMask.playerEntity,
            collisionBitMask: isPlayer
            ? BitMask.enemyEntity
            : BitMask.playerEntity
        )

        let model = LevelCastleModel(
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
                bitmask: BitMask.playerEntity
            )
        case .swordsman:
            return HeroStats(
                manaCost: 15,
                attack: 50,
                health: 100,
                speed: 20,
                bitmask: BitMask.playerEntity
            )
        case .tank:
            return HeroStats(
                manaCost: 20,
                attack: 2,
                health: 200,
                speed: 20,
                bitmask: BitMask.playerEntity
            )
        }
    }

    static func getMonsterStats() -> MonsterStats {
        MonsterStats(
            health: 100,
            attack: 900,
            speed: 20,
            bitmask: BitMask.enemyEntity
        )
    }
}
