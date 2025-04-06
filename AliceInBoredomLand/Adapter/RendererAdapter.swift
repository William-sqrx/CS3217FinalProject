//
//  RendererAdapter.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 5/4/25.
//

import SpriteKit

final class RendererAdapter {
    static func makeNode(from renderable: Renderable) -> SKSpriteNode {
        let spec = renderable.renderSpec
        let node = SKSpriteNode(texture: SKTexture(imageNamed: spec.textureName))
        node.size = spec.size
        node.position = spec.position
        node.zPosition = spec.zPosition
        node.name = spec.name
        return node
    }
}
