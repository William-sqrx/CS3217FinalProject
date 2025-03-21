//
//  BasicMonster.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation
import SpriteKit

class BasicMonster: Monster {
    override func update(deltaTime: TimeInterval) -> any Action {
        print("Monster cooldown:", globalCooldown)
        print("Moster hp", hp)
        _ = super.update(deltaTime: deltaTime)
        let action = selectAction()
        if !(action is NullAction<Monster>) {
            globalCooldown = 3
        }
        return action
    }

    override func selectAction() -> any Action {
        if globalCooldown > 0 {
            return NullAction<Monster>()
        } else {
            // Replace with more detailed logic as needed
            for action in possibleActions
            where action.canSelect.isSatisfied(entity: self) {
                return action
            }
        }
        return NullAction<Monster>()
    }

    init(texture: SKTexture, size: CGSize, hp: Int, speed: CGFloat, baseAttack: Int, gameScene: GameScene) {
        super.init(texture: texture, size: size, hp: hp, speed: speed)

        let collisionCondition = CollisionCondition(base: self)
        gameScene.subscribe(collisionCondition)
        let meleeAttack = MeleeAttackAction<Hero>(
            canSelect: CooldownCondition(specificCooldown: 3),
            canApply: collisionCondition,
            effect: DamageEffect(amount: baseAttack))
        super.possibleActions = [meleeAttack]
    }
}
