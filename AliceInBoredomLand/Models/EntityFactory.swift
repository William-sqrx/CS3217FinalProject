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
        case "archer": return Archer(position: position, size: size)
        case "swordsman": return Swordsman(position: position, size: size)
        case "tank": return Tank(position: position, size: size)
        default: return nil
        }
    }

    func makeMonster(position: CGPoint, size: CGSize) -> Monster {
        return Monster(position: position, size: size)
    }

    func makeCastle(position: CGPoint, size: CGSize, isPlayer: Bool) -> Castle {
        return Castle(position: position, size: size, isPlayer: isPlayer)
    }
}
