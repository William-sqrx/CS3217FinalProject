//
//  Effect.swift
//  AliceInBoredomLand
//
//  Created by daniel on 20/3/25.
//

import Foundation

protocol Effect {
    associatedtype G: GameEntity
    func apply(_ entity: inout G)
}
