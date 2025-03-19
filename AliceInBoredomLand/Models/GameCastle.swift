//
//  GameCastle.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import SpriteKit

class GameCastle: EntityNode {
    init(texture: SKTexture) {
        super.init(texture: texture, health: 500, attack: 0, speed: 0.0, size: castleSize)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func takeDamage(_ amount: Int) {
        health -= amount
        if health <= 0 {
            removeFromParent()
        }
    }
}

