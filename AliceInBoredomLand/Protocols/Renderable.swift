//
//  Renderable.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 5/4/25.
//

import Foundation

protocol Renderable {
    var renderSpec: RenderSpec { get }
}

struct RenderSpec {
    let textureName: String
    let size: CGSize
    let position: CGPoint
    let zPosition: CGFloat
    let name: String
}
