//
//  DeleteOnTouch.swift
//  AliceInBoredomLand
//
//  Created by daniel on 4/4/25.
//

import SpriteKit

class DeleteOnTouch: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromParent()
    }
}
