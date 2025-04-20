//
//  SpriteKitRenderNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 20/4/25.
//

import SpriteKit

class SpriteKitRenderNode: RenderNode {
    let spriteNode: SKSpriteNode
    var onTouch: (() -> Void)?
    var asSKNode: SKNode? { spriteNode }

    init(textureName: String, size: CGSize, position: CGPoint, physics: PhysicsComponent) {
        let texture = SKTexture(imageNamed: textureName)

        // Create spriteNode
        if textureName == "task" {
            let node = InteractiveNode(texture: texture)
            self.spriteNode = node
            node.onTouch = { [weak self] in self?.onTouch?() }
        } else {
            self.spriteNode = SKSpriteNode(texture: texture)
        }

        self.spriteNode.size = size
        self.spriteNode.position = position
        self.spriteNode.zPosition = 1
        self.spriteNode.isUserInteractionEnabled = true

        let body = SKPhysicsBody(rectangleOf: physics.size)
        body.isDynamic = physics.isDynamic
        body.categoryBitMask = physics.categoryBitMask
        body.contactTestBitMask = physics.contactTestBitMask
        body.collisionBitMask = physics.collisionBitMask
        body.affectedByGravity = false
        body.allowsRotation = false
        self.spriteNode.physicsBody = body
    }

    var position: CGPoint {
        get { spriteNode.position }
        set { spriteNode.position = newValue }
    }

    var size: CGSize {
        get { spriteNode.size }
        set { spriteNode.size = newValue }
    }

    var name: String? {
        get { spriteNode.name }
        set { spriteNode.name = newValue }
    }

    var zPosition: CGFloat {
        get { spriteNode.zPosition }
        set { spriteNode.zPosition = newValue }
    }

    var velocity: CGVector {
        get { spriteNode.physicsBody?.velocity ?? .zero }
        set { spriteNode.physicsBody?.velocity = newValue }
    }

    func addToScene(_ scene: Any) {
        if let skScene = scene as? SKScene {
            skScene.addChild(spriteNode)
        }
    }

    func removeFromScene() {
        spriteNode.removeFromParent()
    }

    func setTexture(named: String) {
        spriteNode.texture = SKTexture(imageNamed: named)
    }

    func setUserInteraction(enabled: Bool) {
        spriteNode.isUserInteractionEnabled = enabled
    }

    func setOnTouch(_ handler: @escaping () -> Void) {
        self.onTouch = handler
    }
}
