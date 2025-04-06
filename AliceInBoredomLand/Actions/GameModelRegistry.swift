//
//  GameModelRegistry.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation
import SpriteKit

final class GameModelRegistry {
    static var shared = GameModelRegistry()

    var gameLogicDelegate: GameLogicDelegate?

    var monsterModels: [UUID: OldMonsterModel] = [:]
    var monsterNodes: [UUID: SKSpriteNode] = [:]

    var heroModels: [UUID: OldHeroModel] = [:]
    var heroNodes: [UUID: SKSpriteNode] = [:]

    var castleModels: [UUID: OldGameCastleModel] = [:]
    var castleNodes: [UUID: SKSpriteNode] = [:]

    func getMonsterModel(id: UUID) -> OldMonsterModel? {
        monsterModels[id]
    }

    func setMonsterModel(id: UUID, model: OldMonsterModel) {
        monsterModels[id] = model
    }

    func getMonsterNode(id: UUID) -> SKSpriteNode? {
        monsterNodes[id]
    }

    func setMonsterNode(id: UUID, node: SKSpriteNode) {
        monsterNodes[id] = node
    }

    // Optional for heroes too
    func getHeroModel(id: UUID) -> OldHeroModel? {
        heroModels[id]
    }

    func setHeroModel(id: UUID, model: OldHeroModel) {
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
