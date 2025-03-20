//
//  GameScene+Logic.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 19/3/25.
//

import SpriteKit

extension GameScene {
    override func didMove(to view: SKView) {
        initiateEntities()
        physicsWorld.contactDelegate = self
    }

//    // Handle touch movements
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            // Get the location of the touch in the scene
//            let location = touch.location(in: self)
//            // Update the player's position based on the touch location
//            playerNode.position.x = location.x
//            playerNode.position.y = location.y
//        }
//    }
}
