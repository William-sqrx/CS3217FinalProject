//
//  EntityFactory.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit
import Foundation

class EntityFactory {
    func makeEntity<T: EntityCreatable>(_ type: T.Type, position: CGPoint, size: CGSize) -> GameEntity? {
        type.create(position: position, size: size)
    }
}
