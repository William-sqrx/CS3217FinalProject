//
//  ActionPerformer.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

struct ActionPerformer {
    static func perform(_ action: Action, on node: SKSpriteNode) {
        print("action is", action)
        guard let entityId = node.userData?["entityId"] as? UUID else {
            print("entity not found")
            return
        }
        action.perform(on: node, modelId: entityId)
    }
}
