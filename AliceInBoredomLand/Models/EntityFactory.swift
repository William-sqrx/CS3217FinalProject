//
//  EntityFactory.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit
import Foundation

class EntityFactory {
    func makeHero(type: String, position: CGPoint, size: CGSize) -> Hero? {
        switch type.lowercased() {
        case "archer":
            Archer(position: position, size: size)
        case "swordsman":
            Swordsman(position: position, size: size)
        case "tank":
            Tank(position: position, size: size)
        default:
            nil
        }
    }

    func makeMonster(position: CGPoint, size: CGSize) -> Monster {
        Monster(position: position, size: size)
    }

    func makeCastle(position: CGPoint, size: CGSize, isPlayer: Bool) -> Castle {
        Castle(position: position, size: size, isPlayer: isPlayer)
    }
}
