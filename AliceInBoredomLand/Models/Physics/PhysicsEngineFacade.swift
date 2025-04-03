//
//  PhysicsEngineFacade.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation

protocol PhysicsEngineFacade {
    var boundarySize: CGSize { get }

    func update(dt: TimeInterval) -> [PhysicsEvent]

    mutating func addEntity(_ entity: PhysicsEntity)
    mutating func removeEntity(_ entity: PhysicsEntity)
    mutating func replaceEntity(_ oldEntity: PhysicsEntity, with newEntity: PhysicsEntity)
    mutating func clearAll()
}
