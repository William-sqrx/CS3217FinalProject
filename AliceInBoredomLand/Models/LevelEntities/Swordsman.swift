//
//  Swordsman.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 21/3/25.
//

import Foundation

class Swordsman: Hero {
    init(posX: CGFloat, posY: CGFloat, size: CGSize,
         health: Int = 100, attack: Int = 5, speed: CGFloat = 45) {
        super.init(health: health, attack: attack, speed: speed, posX: posX, posY: posY, size: size)
    }
}
