//
//  Archer.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 20/3/25.
//

import SpriteKit

class Archer: Hero {
    var lastShotTime: TimeInterval = 0
    let shotCooldown: TimeInterval = 0.1
    let attackRange: CGFloat = 500.0

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)

        guard let scene = scene as? GameScene, scene.isMonsterInRange(position, range: attackRange) else {
            return
        }

        let currentTime = CACurrentMediaTime()
        if currentTime - lastShotTime > shotCooldown {
            shootArrow()
            lastShotTime = currentTime
        }
    }

    func shootArrow() {
        guard let scene = self.scene else {
            return
        }

        let arrow = Arrow(damage: self.attack)
        scene.addChild(arrow)

        let direction: CGFloat = 1
        arrow.launch(from: self.position, direction: direction)
    }
}
