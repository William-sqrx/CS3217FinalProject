//
//  GameEngine+GridPositions.swift
//  AliceInBoredomLand
//
//  Created by daniel on 23/3/25.
//

import Foundation

extension GameEngine {

    func getPosition(tileX: Int, tileY: Int) -> CGSize {
        assert(0 <= tileX && tileX < GameEngine.numCols)
        assert(0 <= tileY && tileY < GameEngine.numRows)

        return CGSize(width: Double(tileX) * tileSize.width,
                      height: Double(tileY) * tileSize.height + Double(tileY - 1) * GameEngine.rowSpacing)
    }

    func getNodeSize(numTileX: Int = 1, numTileY: Int = 1) -> CGSize {
        assert(1 <= numTileX && numTileX < GameEngine.numCols)
        assert(1 <= numTileY && numTileY < GameEngine.numRows)

        return CGSize(width: Double(numTileX) * tileSize.width,
                      height: Double(numTileY) * tileSize.height + Double(numTileY - 1) * GameEngine.rowSpacing)
    }

    func adjustEntityOrigin(size: CGSize, position: CGSize) -> CGPoint {
        CGPoint(x: position.width + size.width / 2,
                y: position.height + size.height / 2)
    }
}
