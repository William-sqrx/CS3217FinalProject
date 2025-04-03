//
//  LevelScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

class LevelScene: SKScene {
    var frameCounter = 0
    var gameLogicDelegate: LevelLogicFacade
    var levelViewModel: LevelViewModel
    var grid = Grid()

    init(gameLogicDelegate: LevelLogicFacade, levelViewModel: LevelViewModel, background: SKColor = .gray) {
        self.gameLogicDelegate = gameLogicDelegate
        self.levelViewModel = levelViewModel
        super.init(size: CGSize(width: grid.width, height: grid.height))

        self.backgroundColor = background
        self.scaleMode = .aspectFit
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ currentTime: TimeInterval) {
        levelViewModel.update(currentTime)
        removeAllChildren()
        for entity in levelViewModel.levelEntities {
            addChild(EntityViewFactory.createViewNode(entity: entity))
        }
        for task in levelViewModel.tasks {
            addChild(EntityViewFactory.createViewNode(task: task))
        }
    }

    private func checkWinLose() {
        if gameLogicDelegate.monsterCastleHealth <= 0 {
            showEndLevelLabel(text: "You Win 🎉")
            isPaused = true
            return
        }

        if gameLogicDelegate.playerCastleHealth <= 0 {
            showEndLevelLabel(text: "You Lose 💀")
            isPaused = true
            return
        }
    }

    private func showEndLevelLabel(text: String) {
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Avenir-Heavy"
        label.position = CGPoint(x: grid.width / 2, y: grid.height / 2 + 50)
        label.name = "end_game_label"
        addChild(label)

        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontSize = 30
        restartLabel.fontColor = .yellow
        restartLabel.fontName = "Avenir"
        restartLabel.position = CGPoint(x: grid.width / 2, y: grid.height / 2 - 50)
        restartLabel.name = "restart_button"
        addChild(restartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPaused else {
            return
        }

        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "restart_button" {
                restartLevel()
            }
        }
    }

    private func restartLevel() {
        guard let view = self.view else {
            return
        }

        gameLogicDelegate.reset()

        // let newScene = LevelScene(gameLogicDelegate: gameLogicDelegate)
        // newScene.scaleMode = self.scaleMode
        // view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
