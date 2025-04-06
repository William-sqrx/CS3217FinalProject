//
//  DamageAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

struct DamageAction: Action {
    let amount: Int

    func perform(on node: RenderNode, modelId: UUID) {
        if var hero = GameModelRegistry.shared.getHeroModel(id: modelId) {
            hero.health -= amount
            print("⚠️ Hero took \(amount) damage. Remaining: \(hero.health)")
            GameModelRegistry.shared.setHeroModel(id: hero.id, model: hero)

            if hero.health <= 0 {
                node.remove()
                GameModelRegistry.shared.removeHeroModel(id: modelId)
            }

        } else if var monster = GameModelRegistry.shared.getMonsterModel(id: modelId) {
            monster.health -= amount
            print("💥 Monster took \(amount) damage. Remaining: \(monster.health)")
            GameModelRegistry.shared.setMonsterModel(id: monster.id, model: monster)

            if monster.health <= 0 {
                node.remove()
                GameModelRegistry.shared.removeMonsterModel(id: modelId)
            }
        }
    }
}
