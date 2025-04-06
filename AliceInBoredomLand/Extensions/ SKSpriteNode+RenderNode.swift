//
//   SKSpriteNode+RenderNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit

extension SKSpriteNode: RenderNode {
    func applyVelocity(_ vector: CGVector) {
        self.physicsBody?.velocity = vector
    }

    func remove() {
        self.removeFromParent()
    }
}
