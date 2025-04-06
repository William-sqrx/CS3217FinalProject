//
//  ContentView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 17/3/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var gameLogic = LevelLogic()
    private let gameScene: LevelScene
    private let tileY = 5

    init() {
        let logic = LevelLogic()
        let scene = LevelScene(gameLogicDelegate: logic, grid: Grid())
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
                    // Removed until debugging can be done
                    /*
                    Button("Spawn Archer") {
                        gameScene.spawnHero(type: .archer, atY: tileY)

                    }
                    */

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        gameScene.spawnHero(type: .swordsman, atY: tileY)
                    }

                    Button("Spawn Tank") {
                        gameScene.spawnHero(type: .tank, atY: tileY)
                        print(gameLogic.monsterCastleHealth)
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
