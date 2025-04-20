//
//  EntityCreatable.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/4/25.
//

import Foundation

protocol EntityCreatable {
    static var typeName: String { get }
    static func create(position: CGPoint, size: CGSize) -> GameEntity
}
