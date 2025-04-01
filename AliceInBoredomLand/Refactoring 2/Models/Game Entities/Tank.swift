//
//  Tank.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 21/3/25.
//

import Foundation

class Tank: Hero {
    init(posX: CGFloat, posY: CGFloat, size: CGSize,
         health: Int = 200, attack: Int = 10, speed: CGFloat = 20) {
        super.init(health: health, attack: attack, speed: speed, posX: posX, posY: posY, size: size)
    }
}
