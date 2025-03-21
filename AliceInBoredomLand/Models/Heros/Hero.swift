//
//  Hero.swift
//  AliceInBoredomLand
//
//  Created by daniel on 20/3/25.
//

import Foundation
import SpriteKit

class Hero: SKSpriteNode, HP, GameEntity {
    var id = UUID()
    var hp: Int
    var maxHP: Int
    var globalCooldown: Int

    var isAlive: Bool {
        hp > 0
    }

    func update(deltaTime: TimeInterval) -> any Action {
        physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        globalCooldown = max(0, globalCooldown - 1)
        return selectAction()
    }

    var possibleActions: [any Action]
    func selectAction() -> any Action {
        NullAction<Hero>()
    }

    func collides(with other: any GameEntity) -> Bool {
        self.position == other.position
    }

    init(texture: SKTexture, size: CGSize, hp: Int, speed: CGFloat = 10,
         globalCooldown: Int = 3, possibleActions: [any Action] = []) {
        self.hp = hp
        self.maxHP = hp
        self.globalCooldown = globalCooldown
        self.possibleActions = []

        super.init(texture: texture, color: .clear, size: size)
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = BitMask.Hero.archer
        physicsBody.contactTestBitMask = BitMask.Monster.titan | BitMask.Monster.minion | BitMask.Monster.mage
        physicsBody.linearDamping = 50.0

        self.physicsBody = physicsBody
        self.userData = NSMutableDictionary()
        self.userData?["entity"] = self
        self.speed = speed
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
