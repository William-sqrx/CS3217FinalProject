//
//  Monster.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

class Monster: EntityNode {
    var tilePosition: Int = 0
    override init(texture: SKTexture, health: Int, attack: Int, speed: CGFloat) {
        super.init(texture: texture, health: health, attack: attack, speed: speed)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime: TimeInterval) {
        let moveDistance = CGFloat(speed) * tileSize
        let newPosition = position.x + moveDistance * -1

        if newPosition > 0 {
            position.x = newPosition
        }
    }
}
