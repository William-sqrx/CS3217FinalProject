//
//  LevelView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 20/3/25.
//

import SwiftUI
import SpriteKit

struct LevelView: View {
    @StateObject var gameLogic = GameLogic()

    var gameScene: GameScene {
        let scene = GameScene(gameLogicDelegate: gameLogic)
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    LevelView()
}
