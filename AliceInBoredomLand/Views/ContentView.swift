//
//  ContentView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 17/3/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var levelLogic = LevelLogic()
    private let levelScene: LevelScene
    private let tileY = 5

    init() {
        let logic = LevelLogic()
        let scene = LevelScene(levelLogicDelegate: logic, grid: Grid())
        self._levelLogic = StateObject(wrappedValue: logic)
        self.levelScene = scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: levelScene, debugOptions: [.showsPhysics])
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    // Button to spawn an Archer
                    Button("Spawn Archer") {
                        levelScene.spawnHero(type: "archer", tileY: tileY)
                    }

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        levelScene.spawnHero(type: "swordsman", tileY: tileY)
                    }

                    Button("Spawn Tank") {
                        levelScene.spawnHero(type: "tank", tileY: tileY)
                    }

                    Text("Mana: \(levelLogic.mana)")
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
