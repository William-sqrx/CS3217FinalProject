//
//  LevelView.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation
import SwiftUI
import SpriteKit

struct LevelView: View {
    var gameLogicDelegate = LevelLogic()

    var body: some View {
        ZStack {
            SpriteView(scene: LevelScene(gameLogicDelegate: LevelLogic(),
                                         levelViewModel:
                                            LevelViewModel(levelEngine: LevelEngine(gameLogicDelegate: LevelLogic(),
                                                                                    grid: Grid()))),
                       debugOptions: [.showsPhysics])
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    // Button to spawn an Archer
                    Button("Spawn Archer") {
                        // gameScene.spawnHero(atY: tileY, type: "archer")
                    }

                    // Button to spawn a Swordsman
                    Button("Spawn Swordsman") {
                        // gameScene.spawnHero(atY: tileY, type: "hero")
                    }

                    Button("Spawn Tank") {
                        // gameScene.spawnHero(atY: tileY, type: "tank")
                    }

                    Text("Mana: \(gameLogicDelegate.mana)")
                        .padding()

                    // Add more buttons for different hero types...
                }
                .padding()
            }
        }
    }
}
