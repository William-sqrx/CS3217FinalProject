//
//  LevelModelRegistry.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation

final class LevelModelRegistry {
    static var shared = LevelModelRegistry()

    var gameLogicDelegate: LevelLogicDelegate?

    var monsterModels: [UUID: MonsterModel] = [:]
    var monsterNodes: [UUID: RenderNode] = [:]
    var heroModels: [UUID: HeroModel] = [:]
    var heroNodes: [UUID: RenderNode] = [:]

    var castleModels: [UUID: LevelCastleModel] = [:]
    var castleNodes: [UUID: RenderNode] = [:]

    func getMonsterModel(id: UUID) -> MonsterModel? {
        monsterModels[id]
    }

    func setMonsterModel(id: UUID, model: MonsterModel) {
        monsterModels[id] = model
    }

    func getMonsterNode(id: UUID) -> (RenderNode)? {
        monsterNodes[id]
    }

    func setMonsterNode(id: UUID, node: RenderNode) {
        monsterNodes[id] = node
    }

    // Optional for heroes too
    func getHeroModel(id: UUID) -> HeroModel? {
        heroModels[id]
    }

    func setHeroModel(id: UUID, model: HeroModel) {
        heroModels[id] = model
    }

    func getHeroNode(id: UUID) -> (RenderNode)? {
        heroNodes[id]
    }

    func setHeroNode(id: UUID, node: RenderNode) {
        heroNodes[id] = node
    }

    func removeHeroModel(id: UUID) {
        heroModels.removeValue(forKey: id)
    }

    func removeMonsterModel(id: UUID) {
        monsterModels.removeValue(forKey: id)
    }
}
