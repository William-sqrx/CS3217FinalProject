//
//  ActionPerformer.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation

struct ActionPerformer {
    static func perform(_ action: Action, on node: RenderNode) {
        guard let entityId = node.userData?["entityId"] as? UUID else {
            print("entity not found")
            return
        }
        action.perform(on: node, modelId: entityId)
    }
}
