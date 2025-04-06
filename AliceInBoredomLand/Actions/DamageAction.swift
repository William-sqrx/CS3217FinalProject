//
//  DamageAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation

struct DamageAction: Action {
    let amount: Int

    func perform(on node: RenderNode, modelId: UUID) {
        if var hero = LevelModelRegistry.shared.getHeroModel(id: modelId) {
            hero.health -= amount
            print("⚠️ Hero took \(amount) damage. Remaining: \(hero.health)")
            LevelModelRegistry.shared.setHeroModel(id: hero.id, model: hero)

            if hero.health <= 0 {
                node.remove()
                LevelModelRegistry.shared.removeHeroModel(id: modelId)
            }

        } else if var monster = LevelModelRegistry.shared.getMonsterModel(id: modelId) {
            monster.health -= amount
            print("💥 Monster took \(amount) damage. Remaining: \(monster.health)")
            LevelModelRegistry.shared.setMonsterModel(id: monster.id, model: monster)

            if monster.health <= 0 {
                node.remove()
                LevelModelRegistry.shared.removeMonsterModel(id: modelId)
            }
        }
    }
}
