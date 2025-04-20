//
//  RenderNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 20/4/25.
//

import SpriteKit

protocol RenderNode {
    var asSKNode: SKNode? { get }
    var position: CGPoint { get set }
    var size: CGSize { get set }
    var name: String? { get set }
    var zPosition: CGFloat { get set }
    var velocity: CGVector { get set }

    func addToScene(_ scene: Any)
    func removeFromScene()
    func setTexture(named: String)
    func setUserInteraction(enabled: Bool)
    func setOnTouch(_ handler: @escaping () -> Void)
}
