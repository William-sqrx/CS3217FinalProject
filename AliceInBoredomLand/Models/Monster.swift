//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

class Monster: EntityNode {
    var tilePosition: Int = 0
    private var initialY: CGFloat
    init(texture: SKTexture, size: CGSize, health: Int, attack: Int, speed: CGFloat) {
        self.initialY = 0
        super.init(texture: texture, health: health, attack: attack, speed: speed, size: size)
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = BitMask.Monster.titan
        physicsBody.allowsRotation = false

        self.physicsBody = physicsBody

        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime: TimeInterval) {
        if initialY == 0 { initialY = position.y }
        physicsBody?.velocity = CGVector(dx: speed * -1, dy: 0)
        position.y = initialY
    }
}
