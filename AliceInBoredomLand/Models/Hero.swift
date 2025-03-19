//
//  Hero.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import Swift
import SpriteKit

class Hero: EntityNode {
    let cardID: UUID
    let manaCost: Int
    var tilePosition: Int = 0
    init(texture: SKTexture, health: Int, attack: Int, speed: CGFloat, manaCost: Int) {
        self.cardID = UUID()
        self.manaCost = manaCost
        super.init(texture: texture, health: health, attack: attack, speed: speed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: TimeInterval) {
        let moveDistance = CGFloat(speed) * tileSize
        let newPosition = position.x + moveDistance

        if (newPosition < GameScene.width) {
            position.x = newPosition
        }
    }
}
