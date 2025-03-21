//
//  CollisionCondition.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

class CollisionCondition: Condition, Subscriber {
    typealias V = [(UUID, UUID)]

    func isSatisfied(entity: any GameEntity) -> Bool {
        print(collisionArray)
        print(entity.id, base.id)
        // Reverse order is deliberately not included
        if collisionArray.contains(where: { $0 == (base.id, entity.id) }) {
            print("meow")
            return true
        }
        return false
    }
    func update(_ value: V) {
        self.collisionArray = value
    }

    var collisionArray: V = []
    private let base: GameEntity

    init(base: GameEntity) {
        self.base = base
    }
}

extension CollisionCondition: Equatable {
    static func == (lhs: CollisionCondition, rhs: CollisionCondition) -> Bool {
        lhs.base.id == rhs.base.id
    }
}
