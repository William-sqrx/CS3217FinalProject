//
//  PhysicsEngine.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

protocol PhysicsEngine {
    var boundarySize: CGSize { get }

    func update(dt: TimeInterval) -> [PhysicsEvent]

    mutating func addEntity(_ entity: PhysicsEntity)
    mutating func removeEntity(_ entity: PhysicsEntity)
}
