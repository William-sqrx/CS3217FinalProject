//
//  GameScene+Constants.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/3/25.
//

import UIKit.UIScreen

extension GameScene {
    // Aspect Ratio is what matters here, UI uses implicit scaling I believe
    static let height = 700.0
    static let width = 1_000.0

    static let numRows = 7 // 5 Lanes, 1 For Tasks, 1 for Hero Selection if applicable
    static let numCols = 10

    static let knockbackSpeed: CGFloat = 5
}
