//
//  CGPoint.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 21/3/25.
//

import CoreGraphics

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    func length() -> CGFloat {
        sqrt(x*x + y*y)
    }
}
