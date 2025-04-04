//
//  LevelView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import SwiftUI
import SpriteKit

struct LevelView: View {
    @StateObject var levelScene = LevelScene(levelViewModel:
                                                LevelViewModel(levelEngine:
                                                               LevelEngine(levelLogicDelegate: LevelLogic(),
                                                                           grid: Grid())))
    var body: some View {
        ZStack {
            SpriteView(scene: levelScene,
                       debugOptions: [.showsPhysics])
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Button("Restart Level") {
                        levelScene.restartLevel()
                    }
                    // Button to spawn an Archer
                    Button("Spawn Archer") {
                        levelScene.spawnHero(atY: 5, type: "archer")
                    }

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        levelScene.spawnHero(atY: 5, type: "hero")
                    }

                    Button("Spawn Tank") {
                        levelScene.spawnHero(atY: 5, type: "tank")
                    }

                    Text("Mana: \(levelScene.levelViewModel.levelLogic.mana)")
                        .padding()

                    // Add more buttons for different hero types...
                }
                .padding()
            }
        }
    }
}
