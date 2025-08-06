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
  private var scoreDisplayEntity: GKEntity!

  // MARK: - Scene Lifecycle

  override func didMove(to view: SKView) {
    print("🎮 GameScene: Setting up game...")

    SceneCoordinator.shared.setView(view)

    setupPhysics()
    setupEntities()
    setupSystems()

    AnimationManager.shared.animateSceneEntrance(for: self)

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
    entityManager.addEntity(backgroundEntity) // ADD TO MANAGER
    if let spriteComponent = backgroundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 2. Ground entity
    let groundEntity = EntityFactory.createGround(size: size)
    entityManager.addEntity(groundEntity) // ADD TO MANAGER
    if let spriteComponent = groundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 3. Crab entity (player)
    let crabEntity = EntityFactory.createCrab(
      position: CGPoint(x: size.width / 2, y: size.height * 0.13),
      gameArea: frame
    )
    entityManager.addEntity(crabEntity)
    if let spriteComponent = crabEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 4. Score display entity
    scoreDisplayEntity = EntityFactory.createScoreDisplay(
      position: CGPoint(x: 90, y: size.height - 120)
    )
    entityManager.addEntity(scoreDisplayEntity)
    if let spriteComponent = scoreDisplayEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 5. Pause button entity
    let pauseButtonEntity = EntityFactory.createButton(
      buttonNodeType: .pause,
      position: CGPoint(x: size.width - 50, y: size.height - 75),
      onTap: {
        // .. handle pause here
      }
    )
    entityManager.addEntity(pauseButtonEntity)
    if let spriteComponent = pauseButtonEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 6. Create Recipe Card entity
    let recipeCardEntity = EntityFactory.createRecipeCard(
      position: CGPoint(x: size.width / 2, y: size.height - 210)
    )
    entityManager.addEntity(recipeCardEntity)
    if let spriteComponent = recipeCardEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 7. Create Life Display entity
    let lifeDisplayEntity = EntityFactory.createLifeDisplay(
      position: CGPoint(x: 60, y: size.height - 80)
    )
    entityManager.addEntity(lifeDisplayEntity)
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

    print("🎯 Touch began at: \(location)")

    // Find the entity at touch location
    if let touchedEntity = findEntityAtPoint(location),
       let interaction = touchedEntity.component(ofType: InteractionComponent.self),
       interaction.isEnabled
    {
      print("✅ Found entity with interaction component")
      // Store reference to currently touched entity
      currentTouchedEntity = touchedEntity
      interaction.handleTouchBegan(at: location)
    } else {
      print("⚠️ No interactive entity found at touch location")
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
    var ingredientEntity: GKEntity?
    var crabEntity: GKEntity?

    // Determine which body is fruit and which is basket
    if contact.bodyA.categoryBitMask == PhysicsCategory.ingredient {
      ingredientEntity = findEntityForNode(contact.bodyA.node)
      crabEntity = findEntityForNode(contact.bodyB.node)
    } else if contact.bodyB.categoryBitMask == PhysicsCategory.ingredient {
      ingredientEntity = findEntityForNode(contact.bodyB.node)
      crabEntity = findEntityForNode(contact.bodyA.node)
    }

    guard let ingredient = ingredientEntity,
          let crab = crabEntity,
          let scoreDisplay = scoreDisplayEntity
    else {
      print("⚠️ Could not find entities for collision")
      print("  - Ingredient entity: \(ingredientEntity != nil ? "Found" : "Not found")")
      print("  - Crab entity: \(crabEntity != nil ? "Found" : "Not found")")
      return
    }

    guard let ingredientComponent = ingredient.component(ofType: IngredientComponent.self),
          let ingredientLifecycle = ingredient.component(ofType: LifecycleComponent.self),
          let scoreComponent = scoreDisplay.component(ofType: ScoreComponent.self),
          let crabSprite = crab.component(ofType: SpriteComponent.self) else { return }

    print("🎯 Caught ingredient: \(ingredientComponent.ingredient.name)")
    scoreComponent.addScore(5)

    // Play sound and haptic
    SoundManager.sound.playCorrectSound()
    HapticManager.haptic.playSuccessHaptic()

    // Trigger basket animation if available
    crabSprite.playAnimation(name: "catch")

    // Mark ingredient for removal
    ingredientLifecycle.markForRemoval()
  }

  // MARK: - Helper Methods

  private func findEntityAtPoint(_ location: CGPoint) -> GKEntity? {
    let touchedNode = atPoint(location)

    // Check the touched node and all its parents
    var currentNode: SKNode? = touchedNode
    while let node = currentNode {
      if let entity = findEntityForNode(node) {
        return entity
      }
      currentNode = node.parent
    }

    return nil
  }

  /// Find entity that owns a specific SKNode
  private func findEntityForNode(_ node: SKNode?) -> GKEntity? {
    guard let node else { return nil }

    let allEntities = entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in allEntities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self),
         spriteComponent.node === node || spriteComponent.node === node.parent
      {
        return entity
      }
    }

    return nil
  }
}
