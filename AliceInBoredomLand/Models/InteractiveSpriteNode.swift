//
//  InteractiveSpriteNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/4/25.
//

import SpriteKit

class InteractiveSpriteNode: SKSpriteNode {
    var onTouch: (() -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouch?()
    }
}
