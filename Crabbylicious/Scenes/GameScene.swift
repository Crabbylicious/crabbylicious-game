//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, BaseScene, SKPhysicsContactDelegate {
  // MARK: - Core ECS Components

  let entityManager: EntityManager = .init()
  let systemManager: SystemManager = .init()

  private var lastUpdateTime: TimeInterval = 0
  private var isInitialSetupComplete = false
  private var currentTouchedEntity: GKEntity?

  // MARK: - Scene Lifecycle

  override func didMove(to _: SKView) {
    print("🎮 GameScene: Setting up game...")

    setupPhysics()
    setupEntities()
    setupSystems()

    isInitialSetupComplete = true

    print("✅ GameScene: Setup complete!")
  }

  private func setupPhysics() {
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -2)
  }

  func setupEntities() {
    // 1. Background entity
    let backgroundEntity = EntityFactory.createBackground(size: size)
    if let spriteComponent = backgroundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 2. Ground entity
    let groundEntity = EntityFactory.createGround(size: size)
    if let spriteComponent = groundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 3. Crab entity (player)
    let crabEntity = EntityFactory.createCrab(
      position: CGPoint(x: size.width / 2, y: size.height * 0.13),
      gameArea: frame
    )
    if let spriteComponent = crabEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 4. Score display entity
    let scoreDisplayEntity = EntityFactory.createScoreDisplay(
      position: CGPoint(x: 25, y: size.height - 75)
    )
    if let spriteComponent = scoreDisplayEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 5. Pause button entity
    let pauseButtonEntity = EntityFactory.createButton(
      buttonNodeType: .pause,
      position: CGPoint(x: 25, y: size.height - 100),
      onTap: {
        // .. handle pause here
      }
    )
    if let spriteComponent = pauseButtonEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 6. Create Recipe Card entity
    let recipeCardEntity = EntityFactory.createRecipeCard(
      position: CGPoint(x: size.width / 2, y: size.height - 100)
    )
    if let spriteComponent = recipeCardEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 7. Create Life Display entity
    let lifeDisplayEntity = EntityFactory.createLifeDisplay(
      position: CGPoint(x: size.width / 2, y: size.height - 120)
    )
    if let spriteComponent = lifeDisplayEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }
  }

  func setupSystems() {
    systemManager.addSystems([
      SpawningSystem(),
      RenderingSystem(scene: self),
      LifecycleSystem()
    ])
  }

  override func update(_ currentTime: TimeInterval) {
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }
    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    let context = GameContext(
      scene: self,
      entityManager: entityManager,
      sceneCoordinator: SceneCoordinator.shared
    )

    if isInitialSetupComplete {
      systemManager.update(deltaTime: deltaTime, context: context)
    }
  }

  // MARK: - Input Handling

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)

    // Find the entity at touch location
    if let touchedEntity = findEntityAtPoint(location),
       let interaction = touchedEntity.component(ofType: InteractionComponent.self),
       interaction.isEnabled
    {
      // Store reference to currently touched entity
      currentTouchedEntity = touchedEntity
      interaction.handleTouchBegan(at: location)
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first,
          let currentEntity = currentTouchedEntity,
          let interaction = currentEntity.component(ofType: InteractionComponent.self) else { return }

    let location = touch.location(in: self)

    // Only send touch moved to the currently active entity
    interaction.handleTouchMoved(to: location)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)

    // Handle touch end for the currently touched entity
    if let currentEntity = currentTouchedEntity,
       let interaction = currentEntity.component(ofType: InteractionComponent.self)
    {
      interaction.handleTouchEnded(at: location)
    }

    // Clear the reference
    currentTouchedEntity = nil
  }

  override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
    // Handle touch cancellation
    if let currentEntity = currentTouchedEntity,
       let interaction = currentEntity.component(ofType: InteractionComponent.self)
    {
      interaction.handleTouchCancelled()
    }

    // Clear the reference
    currentTouchedEntity = nil
  }

  // MARK: - HANDLE CONTACT

  func didBegin(_ contact: SKPhysicsContact) {
    var fruitEntity: GKEntity?
    var basketEntity: GKEntity?

    // Determine which body is fruit and which is basket
    if contact.bodyA.categoryBitMask == PhysicsCategory.ingredient {
      fruitEntity = findEntityForNode(contact.bodyA.node)
      basketEntity = findEntityForNode(contact.bodyB.node)
    } else if contact.bodyB.categoryBitMask == PhysicsCategory.ingredient {
      fruitEntity = findEntityForNode(contact.bodyB.node)
      basketEntity = findEntityForNode(contact.bodyA.node)
    }

    guard let fruit = fruitEntity,
          let basket = basketEntity
    else {
      print("⚠️ Could not find entities for collision")
      return
    }

    guard let fruitComponent = fruit.component(ofType: IngredientComponent.self),
          let fruitSprite = fruit.component(ofType: SpriteComponent.self),
          let fruitLifecycle = fruit.component(ofType: LifecycleComponent.self),
          let scoreComponent = basket.component(ofType: ScoreComponent.self),
          let basketSprite = basket.component(ofType: SpriteComponent.self) else { return }

    scoreComponent.addScore(5)

    // Trigger basket animation
    basketSprite.playAnimation(name: "catch")

    // Play fruit caught animation, then remove
    fruitSprite.playAnimation(name: "caught") {
      fruitLifecycle.markForRemoval()
    }
  }

  // MARK: - Helper Methods

  private func findEntityAtPoint(_ location: CGPoint) -> GKEntity? {
    let touchedNode = atPoint(location)
    return findEntityForNode(touchedNode)
  }

  /// Find entity that owns a specific SKNode
  private func findEntityForNode(_ node: SKNode?) -> GKEntity? {
    guard let node else { return nil }

    let allEntities = entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in allEntities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self),
         spriteComponent.node === node
      {
        return entity
      }
    }

    return nil
  }
}
