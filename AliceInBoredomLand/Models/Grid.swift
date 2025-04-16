//
//  Grid.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation

//struct Grid {
//    let width: Double
//    let height: Double
//    let numCols: Int
//    let numLanes: Int
//    let laneSpacing: Double
//    let tileSize: CGSize
//
//    func getPosition(tileX: Int, tileY: Int) -> CGSize {
//        CGSize(width: Double(tileX) * tileSize.width,
//               height: Double(tileY) * tileSize.height + max(Double(tileY - 1), 0) * laneSpacing)
//    }
//
//    func getNodeSize(numTileX: Int = 1, numTileY: Int = 1) -> CGSize {
//        CGSize(width: Double(numTileX) * tileSize.width,
//               height: Double(numTileY) * tileSize.height + Double(numTileY - 1) * laneSpacing)
//    }
//
//    func adjustNodeOrigin(size: CGSize, position: CGSize) -> CGPoint {
//        CGPoint(x: position.width + size.width / 2, y: position.height + size.height / 2)
//    }
//
//    init(width: Double = 1_000, height: Double = 700, numCols: Int = 10, numLanes: Int = 7, laneSpacing: Double = 10) {
//        self.width = width
//        self.height = height
//        self.numCols = numCols
//        self.numLanes = numLanes
//        self.laneSpacing = laneSpacing
//        self.tileSize = CGSize(width: width / Double(numCols), height: (height - laneSpacing * Double(numLanes - 1)) / Double(numLanes))
//    }
//}
