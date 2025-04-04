//
//  EntityViewFactory.swift
//  AliceInBoredomLand
//
//  Created by daniel on 2/4/25.
//

import Foundation
import SpriteKit

struct EntityViewFactory {
    static func createViewNode(entity: LevelEntity) -> SKSpriteNode {
        var result = SKSpriteNode()
        if entity is Swordsman {
            result = SKSpriteNode(texture: SKTexture(imageNamed: "hero"))
        } else if entity is Tank {
            result = SKSpriteNode(texture: SKTexture(imageNamed: "tank"))
        } else if entity is Archer {
            result = SKSpriteNode(texture: SKTexture(imageNamed: "archer"))
        }

        if let entity = entity as? Castle {
            if entity.isPlayer {
                result = SKSpriteNode(texture: SKTexture(imageNamed: "player-castle"))
            } else {
                result = SKSpriteNode(texture: SKTexture(imageNamed: "enemy-castle"))
            }
        }

        if entity is Monster {
            result = SKSpriteNode(texture: SKTexture(imageNamed: "monster"))
        }

        result.size = entity.size
        result.position = CGPoint(x: entity.posX, y: entity.posY)
        return result
    }

    static func createViewNode(task: Task) -> SKSpriteNode {
        let result = SKSpriteNode(texture: SKTexture(imageNamed: "task"))
        result.size = task.size
        result.position = CGPoint(x: task.posX, y: task.posY)

        result.name = "task"
        // Due to SpriteKit bugs, setting this makes touch registration for touchesBegan() impossible
        // See https://stackoverflow.com/questions/19511334/sprite-with-userinteractionenabled
        // -set-to-yes-does-not-receive-touches-when-cove
        // result.isUserInteractionEnabled = true
        return result
    }
}
