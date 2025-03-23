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
    private let gameScene: GameScene

    init() {
        let logic = GameLogic()
        let scene = GameScene(gameLogicDelegate: logic)
        scene.scaleMode = .resizeFill
        self._gameLogic = StateObject(wrappedValue: logic)
        self.gameScene = scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene, debugOptions: [.showsPhysics])
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    // Button to spawn an Archer
                    Button("Spawn Archer") {
                        let tileX = 1 // or pick any valid tile
                        gameScene.spawnHero(atX: tileX, type: "archer")
                    }

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        let tileX = 1
                        gameScene.spawnHero(atX: tileX, type: "hero")
                    }

                    Button("Spawn Tank") {
                        let tileX = 1
                        gameScene.spawnHero(atX: tileX, type: "tank")
                    }

                    Text("Mana: \(gameLogic.mana)")
                        .padding()

                    // Add more buttons for different hero types...
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
