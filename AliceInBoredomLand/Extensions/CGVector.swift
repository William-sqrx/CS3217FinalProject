//
//  CGVector.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import CoreGraphics

extension CGVector {
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }
}
