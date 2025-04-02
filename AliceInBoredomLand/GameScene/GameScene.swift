//
//  GameScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

class GameScene: SKScene {
    var gameLogicDelegate: GameLogicDelegate
    var entities: [GameEntity] = []
    var tasks: [Task] = []
    var frameCounter = 0
    static let width: CGFloat = 700
    static let height: CGFloat = 1_000

    init(gameLogicDelegate: GameLogicDelegate,
         background: SKColor = .gray,
         size: CGSize = CGSize(width: 700, height: 1_000)) {
        self.gameLogicDelegate = gameLogicDelegate
        self.entities = []
        super.init(size: size)
        self.backgroundColor = background
        self.scaleMode = .aspectFit
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func checkWinLose() {
        if gameLogicDelegate.monsterCastleHealth <= 0 {
            showEndGameLabel(text: "You Win 🎉")
            isPaused = true
            return
        }

        if gameLogicDelegate.playerCastleHealth <= 0 {
            showEndGameLabel(text: "You Lose 💀")
            isPaused = true
            return
        }
    }

    private func showEndGameLabel(text: String) {
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Avenir-Heavy"
        label.position = CGPoint(x: GameScene.width / 2, y: GameScene.height / 2 + 50)
        label.name = "end_game_label"
        addChild(label)

        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.fontSize = 30
        restartLabel.fontColor = .yellow
        restartLabel.fontName = "Avenir"
        restartLabel.position = CGPoint(x: GameScene.width / 2, y: GameScene.height / 2 - 50)
        restartLabel.name = "restart_button"
        addChild(restartLabel)
    }

    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPaused else {
            return
        }

        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "restart_button" {
                restartGame()
            }
        }
    }
     */

    private func restartGame() {
        guard let view = self.view else {
            return
        }

        gameLogicDelegate.reset()

        let newScene = GameScene(gameLogicDelegate: gameLogicDelegate)
        newScene.scaleMode = self.scaleMode
        view.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
