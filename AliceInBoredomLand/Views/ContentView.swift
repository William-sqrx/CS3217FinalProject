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
    private let heroTypes: [HeroTypeEntry] = [
        HeroTypeEntry(type: Swordsman.self),
        HeroTypeEntry(type: Tank.self)
    ]


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
                    ForEach(heroTypes) { entry in
                        Button("Spawn \(entry.label)") {
                            gameScene.spawnHero(tileY: tileY, type: entry.type)
                        }
                    }
                    Text("Mana: \(gameLogic.mana)")
                        .padding()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
