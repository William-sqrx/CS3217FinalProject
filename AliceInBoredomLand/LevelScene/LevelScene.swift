//
//  LevelScene.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

import SpriteKit

class LevelScene: SKScene, SKPhysicsContactDelegate {
    var entities: [LevelEntity] = []
    var levelLogicDelegate: LevelLogicDelegate
    var frameCounter = 0
    var grid: Grid
    let factory = EntityFactory()

    init(levelLogicDelegate: LevelLogicDelegate, grid: Grid) {
        self.entities = []
        self.levelLogicDelegate = levelLogicDelegate
        self.grid = grid

        super.init(size: CGSize(width: grid.width, height: grid.height))
        self.backgroundColor = .gray
        self.scaleMode = .aspectFit
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        spawnInitialEntities()
    }

    func spawnInitialEntities() {
        spawnCastle(isPlayer: true)
        spawnCastle(isPlayer: false)
        spawnMonster()
    }

    func spawnHero<T: Hero & EntityCreatable & GridSpawnable>(tileY: Int = 5, type: T.Type) {
        guard let hero = T.spawn(at: 1, tileY: tileY, grid: grid) as? Hero,
              let logic = gameLogicDelegate as? LevelLogic else {
            print("❌ Failed to spawn hero")
            return
        }

        guard logic.mana >= hero.manaCost else {
            print("❌ Not enough mana to spawn \(type.typeName)")
            return
        }

        logic.decreaseMana(by: hero.manaCost)
        if let node = hero.renderNode.asSKNode {
            addChild(node)
        }
        entities.append(hero)
    }

    func spawnMonster() {
        guard let monster = Monster.spawn(at: 8, tileY: 5, grid: grid) as? Monster else {
            return
        }
        if let node = monster.renderNode.asSKNode {
            addChild(node)
        }
        entities.append(monster)
    }

    func spawnCastle(isPlayer: Bool) {
        let size = grid.getNodeSize(numTileY: 5)
        let tileX = isPlayer ? 0 : (grid.numCols - 1)
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: tileX, tileY: 2))
        guard let castle = Castle(position: pos, size: size, isPlayer: isPlayer) as? Castle else {
            return
        }
        if let node = castle.renderNode.asSKNode {
            addChild(node)
        }
        entities.append(castle)
    }

    func spawnProjectile(type: String, isPlayer: Bool, size: CGSize, position: CGPoint, damage: Int) {
        let projectile = factory.makeProjectile(type: "arrow",
                                               isPlayer: isPlayer, size: size, position: position, damage: damage)
        addChild(projectile)
        entities.append(projectile)
    }

    func spawnTask() {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: grid.numCols - 1, tileY: 1))
        let task = Task(position: pos, size: size)
        addChild(task)
        entities.append(task)
    }

    override func update(_ currentTime: TimeInterval) {
        frameCounter += 1
        if frameCounter.isMultiple(of: 30) {
            performFrameLogic(currentTime: currentTime)
        }
    }

    private func performFrameLogic(currentTime: TimeInterval) {
        let deltaTime: TimeInterval = 1.0
        if frameCounter.isMultiple(of: 180) {
            spawnTask()
        }

        for entity in entities {
            entity.update(deltaTime: deltaTime)
            if let hero = entity as? Hero, hero.shouldAttack(currentTime: currentTime) {
                hero.lastAttackTime = currentTime
            }
            if let archer = entity as? Archer {
                for otherEntity in entities where
                abs(archer.position.x - otherEntity.position.x) < archer.attackRange && otherEntity is Monster {
                    spawnProjectile(type: "",
                                    isPlayer: true, size: Arrow.arrowSize, position: archer.position, damage: 20)
                }
            }
        }

        removeDeadEntities()
        checkWinLose()
    }

    func spawnTask() {
        let size = grid.getNodeSize()
        let pos = grid.adjustNodeOrigin(size: size, position: grid.getPosition(tileX: grid.numCols - 1, tileY: 1))
        let task = Task(position: pos, size: size)
        if let node = task.renderNode.asSKNode {
            node.isUserInteractionEnabled = true
            (node as? InteractiveNode)?.onTouch = { [weak self, weak task] in
                guard let self = self, let task = task else { return }
                if let logic = self.gameLogicDelegate as? LevelLogic {
                    logic.increaseMana(by: 10)
                }
                task.renderNode.removeFromScene()
            }
            addChild(node)
        }
        entities.append(task)
    }

    private func removeDeadEntities() {
        entities.removeAll { entity in
            if entity.health <= 0 {
                entity.renderNode.removeFromScene()
                return true
            }
            return false
        }
    }

    private func checkWinLose() {
        guard let logic = levelLogicDelegate as? LevelLogic else {
            return
        }

        if logic.monsterCastleHealth <= 0 {
            endLevel(text: "You Win 🎉")
        } else if logic.playerCastleHealth <= 0 {
            endLevel(text: "You Lose 💀")
        }
    }

    private func endLevel(text: String) {
        isPaused = true
        let label = SKLabelNode(text: text)
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Avenir-Heavy"
        label.position = CGPoint(x: grid.width / 2, y: grid.height / 2 + 50)
        addChild(label)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node else { return }

        guard let entityA = entities.first(where: { $0.renderNode.asSKNode === nodeA }),
              let entityB = entities.first(where: { $0.renderNode.asSKNode === nodeB }) else { return }

        let names = [entityA.renderNode.name, entityB.renderNode.name]

        if names.contains("monster") && names.contains("player-castle") {
            print("✅ Monster collided with player castle")
            if let castle = [entityA, entityB].first(where: { $0.renderNode.name == "player-castle" }) {
                ActionPerformer.perform(DamageAction(amount: 1000), on: castle)
                if let logic = gameLogicDelegate as? LevelLogic {
                    logic.playerCastleHealth -= 1000
                }
            }
        }

        if names.contains("hero") && names.contains("monster-castle") {
            print("✅ Hero collided with monster castle")
            if let castle = [entityA, entityB].first(where: { $0.renderNode.name == "monster-castle" }) {
                ActionPerformer.perform(DamageAction(amount: 10), on: castle)
                if let logic = levelLogicDelegate as? LevelLogic {
                    logic.monsterCastleHealth -= 10
                }
            }
        }

        if let monster = [entityA, entityB].first(where: { $0.renderNode.name == "monster" }),
           let hero = [entityA, entityB].first(where: { $0.renderNode.name == "hero" }) {
            print("✅ Monster collided with hero")
            ActionPerformer.perform(KnockbackAction(direction: CGVector(dx: 1, dy: 0), duration: 0.2, speed: 30),
                                    on: monster)
            ActionPerformer.perform(KnockbackAction(direction: CGVector(dx: -1, dy: 0), duration: 0.2, speed: 30),
                                    on: hero)

            ActionPerformer.perform(DamageAction(amount: monster.attack), on: hero)
            ActionPerformer.perform(DamageAction(amount: hero.attack), on: monster)
        }
    }
}
