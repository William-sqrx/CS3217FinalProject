//
//  KnockBackAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit
import Foundation

struct KnockbackAction: Action {
    let direction: CGVector
    let duration: TimeInterval
    let speed: CGFloat

    func perform(on node: SKSpriteNode, modelId: UUID) {
        node.physicsBody?.velocity = direction * speed

        if var model = GameModelRegistry.shared.getMonsterModel(id: modelId) {
            model.knockbackTimer = duration
            GameModelRegistry.shared.setMonsterModel(id: model.id, model: model)
        } else if var model = GameModelRegistry.shared.getHeroModel(id: modelId) {
            model.knockbackTimer = duration
            GameModelRegistry.shared.setHeroModel(id: model.id, model: model)
        }
    }
}
