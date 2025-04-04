//
//  LevelView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import SwiftUI
import SpriteKit

struct LevelView: View {
    @StateObject var levelViewModel = LevelViewModel(levelEngine:
                                                            LevelEngine(levelLogicDelegate: LevelLogic(), grid: Grid()))
    var body: some View {
        ZStack {
            SpriteView(scene: LevelScene(levelViewModel: levelViewModel),
                       debugOptions: [.showsPhysics])
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Button("Restart Level") {
                        levelViewModel.restartLevel()
                    }
                    // Button to spawn an Archer
                    Button("Spawn Archer") {
                        levelViewModel.spawnHero(atY: 5, type: "archer")
                    }

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        levelViewModel.spawnHero(atY: 5, type: "hero")
                        print("woof", levelViewModel.levelLogic.mana)
                    }

                    Button("Spawn Tank") {
                        levelViewModel.spawnHero(atY: 5, type: "tank")
                    }

                    Text("Mana: \(levelViewModel.levelLogic.mana)")
                        .padding()

                    // Add more buttons for different hero types...
                }
                .padding()
            }
        }
    }
}
