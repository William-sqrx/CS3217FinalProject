//
//  Swordsman.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 21/3/25.
//

import SpriteKit

class Swordsman: Hero {
    override init(texture: SKTexture, size: CGSize,
                  health: Int = 100, attack: Int = 150, speed: CGFloat = 45, manaCost: Int = 15) {
        super.init(texture: texture, size: size,
                   health: health, attack: attack, speed: speed, manaCost: manaCost)
        self.physicsBody?.categoryBitMask = OldBitMask.Hero.swordsman
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
