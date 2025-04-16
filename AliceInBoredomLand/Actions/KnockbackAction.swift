//
//  KnockbackAction.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import SpriteKit
import Foundation

struct KnockbackAction: Action {
    let direction: CGVector
    let duration: TimeInterval
    let speed: CGFloat
    func perform(on target: GameEntity) {
        target.velocity = direction * speed
        target.knockbackTimer = duration
    }
}
