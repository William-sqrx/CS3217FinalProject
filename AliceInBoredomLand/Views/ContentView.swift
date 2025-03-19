//
//  ContentView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 17/3/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
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
    ContentView()
}
