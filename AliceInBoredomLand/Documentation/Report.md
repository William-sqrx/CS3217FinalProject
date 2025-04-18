# 📘 AliceInBoredomLand — Developer Guide & Sprint Documentation

---

## I. Requirements

### 1. Overview

AliceInBoredomLand is a grid-based castle defense game where players deploy heros on tiles using resources to intercept and defeat monsters marching from the right side of the screen.\
If the player manages to destroy the monster castle, they win; while if the monster(s) manage to destroy the player castle, the player loses.\
This game supports hero placement on multiple lanes, real-time attack resolution.

### 2. Specifications

- **Grid-Based Gameplay:** The game board follows a chess-like grid system, primarily for entity spawning and sizing. However, movement is continuous and not restricted to grid locations.
- **Lane-Based Combat:** Heroes and monsters remain in fixed horizontal lanes, simplifying movement logic while retaining strategic depth.
- **Hero Deployment:** Players deploy heroes (Archer, Tank, Swordsman) by clicking buttons if they have sufficient mana. Mana is earned by tapping tasks that appear at set intervals, and some mana is given at the start.
- **Entity Statistics**: Each hero or monster has an health, attack and speed value, that respectively defines how much damage it can take before dying, how much damage it can deal in a single attack, and how fast it can move.
- **Projectile Mechanics:** Archers fire arrows at enemies within range, adhering to cooldown mechanics.
- **Physics-Based Interactions:** Collision and contact detection governs interactions between arrows, monsters, castles, and heroes.\
All collision bounding boxes are rectangles, matching visual node sizes.\
Heroes and monsters stack upon meeting opposition, leading to group damage interactions for melee units.\
- **Contact Handling:** Distinction between collision and contact is minimal for now but may evolve.\
Melee attacks currently damage all stacked enemies within contact.\
Ranged attacks despawn immediately upon hitting a valid target.\


### 3. User Manual

- **Start Game**: Game auto-launches upon running the app.
- **Deploy Hero**: Tap the button in the UI to spawn the corresponding hero in the given location, this does not work if there is insufficient mana.
- **Task Completion**: Tap the tasks as they appear from the right to gain resources that can be used to summon heroes.
- **Combat**: Occurs automatically in real time.
- **Victory/Loss**: Shown via modal alert.
- **Platform**: iOS 16+, landscape only.
- **Limitations**: No persistent save, sound or animations yet. Restart feature is currently buggy and does not fully work.

---

## II. Design

### 1. Overview

#### Top-Level Organization and Key Classes

- The class within `LevelScene` and its extensions orchestrates the game loop, spawning, updates, and interactions.
- The `Model` folder contains model information for the rest of the game, and also has the subfolders `Level Entities` and `Actions` that contain classes pertaining to the heros and monsters involved, and what these can perform respectively.
    - `EntityFactory` instantiates entities based on type.
    - `LevelEntity` is the base type for all dynamic objects.
    - Game state stored and manipulated to UI display via `LevelLogic` (conforming to `LevelLogicDelegate`).
- `Protocols`, `Utils` and `Extensions` respectively contain useful protocols for conforming to, utility functions that don't fit in any particular category, and extensions to native classes that are needed to make the code work.
- `Adapter` is currently unused, but otherwise allows for classes to be adapted into a form that complies with other protocols.
- Lastly, `View` handles displaying the model information to the user, and conveying user input to the models through `LevelScene`.

#### Design Issues

- Mixing logic with SpriteKit entities: tradeoff between encapsulation vs. rendering coupling.
- Use of string-based type switching in factory is brittle.
- Position logic manually computed using grid size (improvement: reusable positioning helpers).

#### Libraries Used

- **SpriteKit**: Game rendering and physics.
- **SwiftUI**: UI and touch input layer.

#### Likely to Change

- Hero `act()` strategies could be decoupled from entity.
- `EntityFactory` may evolve into polymorphic creators.
- Level logic could support scripting.

---

### 2. Runtime Structure

#### `LevelScene`

- Main simulation driver (`update()` method).
- Holds and updates all `LevelEntity` objects.
- Handles collision via `SKPhysicsContactDelegate`.

#### `LevelEntity`

- Base class with movement, physics, health, and damage.
- Uses composition for physics body setup.

#### `Hero` subclass

- Includes attack range, cooldown, mana cost.
- Subtypes include `Swordsman`, `Archer`, `Tank`.
- Updates velocity and invokes projectile spawn.

#### `Grid`

- Provides grid-to-position translation.
- Handles tile size calculation and node positioning.

---

### 3. Module Structure

```
AliceInBoredomLand/
├── ContentView.swift            # SwiftUI entry point
├── LevelScene.swift            # SKScene game loop
├── EntityFactory.swift         # Instantiates game entities
├── LevelEntity.swift           # Base class for all entities
├── Hero.swift (and subclasses)
├── Monster.swift / Castle.swift / Arrow.swift / Task.swift
```

#### Patterns Used

- **Factory**: `EntityFactory` instantiates entities.
- **Delegate**: `LevelLogicDelegate` for external logic control.
- **Strategy (future)**: Decoupling `update`/`act` behaviors.

---

## III. Documenting Code

### `LevelEntity`

- **Fields**: `velocity`, `health`, `attack`, `moveSpeed`, `physicsBody`, etc.
- **Rep Invariants**: health >= 0; velocity finite; non-nil texture.
- **Abstraction Function**: Entity position in scene <-> grid position in game logic.

### `Hero`

- Adds attack cooldown and mana cost.
- `shouldAttack(currentTime:)` determines projectile spawn.
- Different subtypes change stats and logic slightly.

---

## IV. Testing

### 1. Strategy

- Manual playtesting for behavior validation.
- Unit tests planned for `LevelLogic` and `Grid` calculations.
- `update` loop covered through simulated `currentTime` injection.
- Contact testing via mocked `SKPhysicsContact`.

### 2. Results

- Spawning and logic updates confirmed stable.
- Collision response works under controlled tests.
- No concurrency or timing bugs observed.

---

## V. Reflection

### 1. Evaluation

- Integration of SpriteKit and SwiftUI was successful.
- Code quality stable but coupling between rendering and logic still high.
- Collision handling robust; factory pattern usable but not elegant.

### 2. Lessons

- SpriteKit scenes benefit from data-driven layout.
- Avoid logic in SKNode subclasses where possible.
- Need better abstraction for hero-specific logic.

### 3. Known Bugs / Limitations

- Factory relies on strings ("archer", "tank") — easy to mistype.
- Touch input limited to fixed tileY.
- No animation or sound support yet.

---

## VI. Appendix

### Formats

- Hero names: "archer", "tank", "swordsman"
- Physics categories hardcoded in `PhysicsComponent` definitions.

### Module Specs

- `Grid`: Converts between tile coordinates and scene coordinates.
- `LevelScene`: Scene controller and entity manager.

### Test Cases

- `spawnHero()`: Succeeds if mana sufficient and position valid.
- `update()`: Entities move, collide, and health is decremented.
- `didBegin(contact)`: Validates damage and knockback effects.

### Task List

| Task                         | Owner | Status   |
|------------------------------|-------|----------|
| Entity factory implementation| Dev A | Complete |
| SpriteKit collision system   | Dev B | Complete |
| Hero class hierarchy         | Dev C | Complete |
| SwiftUI interface & buttons  | Dev D | Ongoing  |
| Test physics + damage logic  | Dev A | Planned  |

### GUI Sketches

- Bottom bar with buttons (SwiftUI `HStack`)
- Center `SpriteView` showing animated grid
