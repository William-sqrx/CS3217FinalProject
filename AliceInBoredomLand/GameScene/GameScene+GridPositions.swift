//
//  GameScene+GridPositions.swift
//  AliceInBoredomLand
//
//  Created by daniel on 23/3/25.
//

import Foundation
import SpriteKit

extension GameScene {

    func getPosition(tileX: Int, tileY: Int) -> CGSize {
        assert(0 <= tileX && tileX < GameScene.numCols)
        assert(0 <= tileY && tileY < GameScene.numRows)

        return CGSize(width: Double(tileX) * tileSize.width,
                      height: Double(tileY) * tileSize.height + Double(tileY - 1) * GameScene.rowSpacing)
    }

    func getNodeSize(numTileX: Int = 1, numTileY: Int = 1) -> CGSize {
        assert(1 <= numTileX && numTileX < GameScene.numCols)
        assert(1 <= numTileY && numTileY < GameScene.numRows)

        return CGSize(width: Double(numTileX) * tileSize.width,
                      height: Double(numTileY) * tileSize.height + Double(numTileY - 1) * GameScene.rowSpacing)
    }

    func adjustNodeOrigin(node: SKSpriteNode, position: CGSize) -> CGPoint {
        CGPoint(x: position.width + node.size.width / 2,
                y: position.height + node.size.height / 2)
    }
}
