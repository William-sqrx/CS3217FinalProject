//
//  RenderNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 6/4/25.
//

import Foundation
import SpriteKit

protocol RenderNode {
    var position: CGPoint { get set }
    var name: String? { get set }
    var zPosition: CGFloat { get set }
    var size: CGSize { get set }

    var userData: NSMutableDictionary? { get set }
    var physicsBody: SKPhysicsBody? { get set }

    func applyVelocity(_ vector: CGVector)
    func remove()
}
