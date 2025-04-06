//
//  OldPhysicsComponent.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 1/4/25.
//

import Foundation

struct OldPhysicsComponent {
    var size: CGSize
    var isDynamic: Bool
    var categoryBitMask: UInt32
    var contactTestBitMask: UInt32
    var collisionBitMask: UInt32
}
