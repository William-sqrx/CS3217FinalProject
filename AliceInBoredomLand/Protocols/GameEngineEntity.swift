//
//  GameEngineEntity.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/4/25.
//

import Foundation

protocol GameEngineEntity {
    var health: Int { get set }
    var attack: Int { get }
    var velocity: CGVector { get set }
    var knockbackTimer: TimeInterval { get set }

    func takeDamage(_ amount: Int)
    func update(deltaTime: TimeInterval)
}
