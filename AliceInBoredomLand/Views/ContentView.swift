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
    private let heroTypes: [HeroTypeEntry] = [
        HeroTypeEntry(type: Swordsman.self),
        HeroTypeEntry(type: Tank.self)
    ]


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
