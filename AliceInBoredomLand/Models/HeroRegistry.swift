//
//  HeroRegistry.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/4/25.
//

import Foundation

struct HeroRegistry {
    let heroTypes: [HeroTypeEntry] = [
        HeroTypeEntry(type: Swordsman.self),
        HeroTypeEntry(type: Tank.self)
    ]
}
