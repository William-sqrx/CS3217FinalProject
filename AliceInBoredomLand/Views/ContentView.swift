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
    private let tileY = 5

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
                        gameScene.spawnHero(atY: tileY, type: .archer)
                    }

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        gameScene.spawnHero(atY: tileY, type: .swordsman)
                    }

                    Button("Spawn Tank") {
                        gameScene.spawnHero(atY: tileY, type: .tank)
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
