//
//  Swordsman.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 21/3/25.
//

import SpriteKit

class Swordsman: Hero {
    init(posX: CGFloat, posY: CGFloat, width: Double, height: Double,
         health: Int = 100, attack: Int = 50, speed: CGFloat = 45) {
        super.init(health: health, attack: attack, speed: speed, posX: posX, posY: posY, width: width, height: height)
    }
}
