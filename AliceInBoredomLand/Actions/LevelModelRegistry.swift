//
//  LevelModelRegistry.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation
import SpriteKit

final class LevelModelRegistry {
    static var shared = LevelModelRegistry()

    var gameLogicDelegate: LevelLogicDelegate?

    var monsterModels: [UUID: MonsterModel] = [:]
    var monsterNodes: [UUID: SKSpriteNode] = [:]

    var heroModels: [UUID: HeroModel] = [:]
    var heroNodes: [UUID: SKSpriteNode] = [:]

    var castleModels: [UUID: LevelCastleModel] = [:]
    var castleNodes: [UUID: SKSpriteNode] = [:]

    func getMonsterModel(id: UUID) -> MonsterModel? {
        monsterModels[id]
    }

    func setMonsterModel(id: UUID, model: MonsterModel) {
        monsterModels[id] = model
    }

    func getMonsterNode(id: UUID) -> SKSpriteNode? {
        monsterNodes[id]
    }

    func setMonsterNode(id: UUID, node: SKSpriteNode) {
        monsterNodes[id] = node
    }

    // Optional for heroes too
    func getHeroModel(id: UUID) -> HeroModel? {
        heroModels[id]
    }

    func setHeroModel(id: UUID, model: HeroModel) {
        heroModels[id] = model
    }

    func getHeroNode(id: UUID) -> SKSpriteNode? {
        heroNodes[id]
    }

    func setHeroNode(id: UUID, node: SKSpriteNode) {
        heroNodes[id] = node
    }

    func removeHeroModel(id: UUID) {
        heroModels.removeValue(forKey: id)
    }

    func removeMonsterModel(id: UUID) {
        monsterModels.removeValue(forKey: id)
    }
}
