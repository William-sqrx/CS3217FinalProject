//
//  InteractiveNode.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 20/4/25.
//

import SpriteKit

class InteractiveNode: SKSpriteNode {
    var onTouch: (() -> Void)?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouch?()
    }
}
