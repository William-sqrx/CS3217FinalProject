//
//  PhysicsEngineImpl.swift
//  AliceInBoredomLand
//
//  Created by daniel on 30/3/25.
//

import Foundation
import SpriteKit

struct PhysicsEngineImpl: PhysicsEngine {
    var boundarySize: CGSize
    var physicsScene: SKScene

    func update(dt: TimeInterval) -> [any PhysicsEvent] {
        physicsScene.update(dt)
        return []
    }

    func addEntity(_ entity: any PhysicsEntity) {
        return
    }

    func removeEntity(_ entity: any PhysicsEntity) {
        return
    }

    init(boundarySize: CGSize) {
        self.boundarySize = boundarySize
        physicsScene = SKScene(size: boundarySize)
    }
}
