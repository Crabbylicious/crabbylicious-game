//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, BaseScene, SKPhysicsContactDelegate, PauseOverlayDelegate {
  // MARK: - Core ECS Components

  let entityManager: EntityManager = .init()
  let systemManager: SystemManager = .init()
  let gameState: GameState = .shared

  private var lastUpdateTime: TimeInterval = 0
  private var isInitialSetupComplete = false
  private var currentTouchedEntity: GKEntity?

  private var scoreDisplayEntity: GKEntity!
  private var lifeDisplayEntity: GKEntity!
  private var crabEntity: GKEntity!
  private var pauseButtonEntity: GKEntity!
  private var recipeCardEntity: GKEntity!
  private var pauseOverlay: PauseOverlay?

  // MARK: - Scene Lifecycle

  override func didMove(to view: SKView) {
    SceneCoordinator.shared.setView(view)

    setupPhysics()
    setupEntities()
    setupSystems()

    AnimationManager.shared.animateSceneEntrance(for: self)

    isInitialSetupComplete = true
  }

  private func setupPhysics() {
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = CGVector(dx: 0, dy: -2)

    // Enable physics body visualization for debugging
    view?.showsPhysics = true
  }

  func setupEntities() {
    // 1. Background entity
    let backgroundEntity = EntityFactory.createBackground(size: size)
    entityManager.addEntity(backgroundEntity)
    if let spriteComponent = backgroundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 2. Bubble Background entity
    let bubbleBackgroundEntity = EntityFactory.createBubbleBackground(
      size: size,
      position: CGPoint(x: size.width / 2, y: size.height) // Start from bottom off-screen
    )
    entityManager.addEntity(bubbleBackgroundEntity)
    if let spriteComponent = bubbleBackgroundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 3. Ground entity
    let groundEntity = EntityFactory.createGround(
      position: CGPoint(x: size.width / 2, y: 40)
    )
    entityManager.addEntity(groundEntity)
    if let spriteComponent = groundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 4. Crab entity (player)
    crabEntity = EntityFactory.createCrab(
      position: CGPoint(x: size.width / 2, y: size.height * 0.13),
      gameArea: frame
    )
    entityManager.addEntity(crabEntity)
    if let spriteComponent = crabEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 5. Score display entity
    scoreDisplayEntity = EntityFactory.createScoreDisplay(
      position: CGPoint(x: 90, y: size.height - 120)
    )
    entityManager.addEntity(scoreDisplayEntity)
    if let spriteComponent = scoreDisplayEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 6. Pause Button entity
    pauseButtonEntity = EntityFactory.createButton(
      buttonNodeType: .pause,
      position: CGPoint(x: size.width - 50, y: size.height - 75),
      onTap: { [weak self] in
        self?.handlePauseButtonTap()
      }
    )
    entityManager.addEntity(pauseButtonEntity)
    if let spriteComponent = pauseButtonEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 7. Recipe Card Entity
    recipeCardEntity = EntityFactory.createRecipeCard(
      position: CGPoint(x: size.width / 2, y: size.height - 210)
    )
    entityManager.addEntity(recipeCardEntity)
    if let spriteComponent = recipeCardEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 8. Create Life Display entity
    lifeDisplayEntity = EntityFactory.createLifeDisplay(
      position: CGPoint(x: 60, y: size.height - 80)
    )
    entityManager.addEntity(lifeDisplayEntity)
    if let spriteComponent = lifeDisplayEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }
  }

  private func setupSystems() {
    systemManager.addSystems([
      BubbleBackgroundSystem(),
      SpawningSystem(),
      ScoreAndLifeNodeUpdateSystem(),
      OverlayManagementSystem(),
      RenderingSystem(scene: self),
      LifecycleSystem()
    ])
  }

  override func update(_ currentTime: TimeInterval) {
    // Don't update systems if paused
    guard gameState.state != .paused else { return }

    let deltaTime = lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0
    lastUpdateTime = currentTime

    if isInitialSetupComplete {
      let context = GameContext(
        scene: self,
        entityManager: entityManager,
        sceneCoordinator: SceneCoordinator.shared,
        gameState: gameState
      )
      systemManager.update(deltaTime: deltaTime, context: context)
    }
  }

  // MARK: - Input Handling

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)
    // Always allow button touches (pause button should work when paused)
    if location.y >= size.height * 0.9, location.x >= size.width * 0.8 {
      // handle button touch
      // Find the entity at touch location
      if let interaction = pauseButtonEntity.component(ofType: InteractionComponent.self) {
        currentTouchedEntity = pauseButtonEntity
        interaction.handleTouchBegan(at: location)
      }
      return
    }

    // Only process game area touches if not paused
    guard gameState.state != .paused else { return }

    if location.y < size.height * 0.7 {
      // interaction in game area
      if let interaction = crabEntity.component(ofType: InteractionComponent.self),
         let spriteComponent = crabEntity.component(ofType: SpriteComponent.self)
      {
        currentTouchedEntity = crabEntity
        interaction.handleTouchBegan(at: location)
        spriteComponent.playAnimation(name: "walk")
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first,
          let interaction = crabEntity.component(ofType: InteractionComponent.self) else { return }

    let location = touch.location(in: self)

    // Only send touch moved to the currently active entity
    interaction.handleTouchMoved(to: location)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)

    // Handle touch end for the currently touched entity
    if let currentEntity = currentTouchedEntity,
       let interaction = currentEntity.component(ofType: InteractionComponent.self),
       let spriteComponent = currentEntity.component(ofType: SpriteComponent.self)
    {
      interaction.handleTouchEnded(at: location)
      spriteComponent.stopAnimation(withKey: "walk")
    }

    // Clear the reference
    currentTouchedEntity = nil
  }

  override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
    // Handle touch cancellation
    if let currentEntity = currentTouchedEntity,
       let interaction = currentEntity.component(ofType: InteractionComponent.self),
       let spriteComponent = currentEntity.component(ofType: SpriteComponent.self)
    {
      interaction.handleTouchCancelled()
      spriteComponent.stopAnimation(withKey: "walk")
    }

    // Clear the reference
    currentTouchedEntity = nil
  }

  // MARK: - HANDLE CONTACT

  func didBegin(_ contact: SKPhysicsContact) {
    guard gameState.state == .playing else { return }

    var ingredientEntity: GKEntity?

    // Determine which body is ingredient and which is crab/ground
    if contact.bodyA.categoryBitMask == PhysicsCategory.ingredient {
      ingredientEntity = findEntityForNode(contact.bodyA.node)
    } else if contact.bodyB.categoryBitMask == PhysicsCategory.ingredient {
      ingredientEntity = findEntityForNode(contact.bodyB.node)
    }

    guard let ingredient = ingredientEntity,
          let ingredientComponent = ingredient.component(ofType: IngredientComponent.self)
    else { return }

    guard let ingredientLifecycle = ingredient.component(ofType: LifecycleComponent.self),
          let crabSprite = crabEntity.component(ofType: SpriteComponent.self),
          let recipeComponent = recipeCardEntity.component(ofType: CurrentRecipeComponent.self),
          let spriteComponent = recipeCardEntity.component(ofType: SpriteComponent.self),
          let recipeCardNode = spriteComponent.node as? RecipeCardNode else { return }

    let isNeededIngredient = recipeComponent.currentRecipe.ingredients[ingredientComponent.ingredient] != nil
    let collectedCount = recipeComponent.collectedIngredients[ingredientComponent.ingredient] ?? 0
    let requiredCount = recipeComponent.currentRecipe.ingredients[ingredientComponent.ingredient] ?? 0

    if isNeededIngredient, collectedCount < requiredCount {
      // This ingredient is needed and we haven't collected enough yet
      recipeComponent.caughtIngredient(ingredientComponent.ingredient)

      // Update the visual display
      let remainingCount = max(0, requiredCount - (collectedCount + 1))
      recipeCardNode.updateIngredientCount(ingredientComponent.ingredient, remainingCount)

      // Add points for correct ingredient
      if let scoreComponent = scoreDisplayEntity.component(ofType: ScoreComponent.self) {
        scoreComponent.addScore(5)
      }

      // Increment total ingredients caught counter for dynamic difficulty
      gameState.incrementIngredientsCaught()

      SoundManager.sound.playCorrectSound()
      HapticManager.haptic.playSuccessHaptic()

    } else {
      // Wrong ingredient or already have enough
      if let lifeComponent = lifeDisplayEntity.component(ofType: LifeComponent.self) {
        lifeComponent.loseLife()

        if lifeComponent.isGameOver() {
          gameState.gameOver()
        }
      }

      // Even wrong ingredients count towards difficulty progression
      gameState.incrementIngredientsCaught()

      SoundManager.sound.playWrongSound()
      HapticManager.haptic.playFailureHaptic()
    }

    // Check if recipe is completed
    if recipeComponent.isRecipeCompleted {
      gameState.completeRecipe()

      // Prepare for next recipe
      gameState.currentRecipeIndex = (gameState.currentRecipeIndex + 1) % GameData.recipes.count
      let nextRecipe = GameData.recipes[gameState.currentRecipeIndex]

      // Reset recipe component for next recipe
      recipeComponent.updateRecipe(nextRecipe)
      recipeCardNode.updateRecipe(nextRecipe)

      // Play completion sound
      SoundManager.sound.playCorrectSound()
      HapticManager.haptic.playSuccessHaptic()
    }

    // Trigger crab animation if available
    crabSprite.playAnimation(name: "catch")

    // Mark ingredient for removal
    ingredientLifecycle.markForRemoval()
  }

  // MARK: - Helper Methods

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

  // MARK: - Pause Functionality

  private func handlePauseButtonTap() {
    guard gameState.state == .playing else { return }

    gameState.pauseGame()
    showPauseOverlay()
  }

  private func showPauseOverlay() {
    guard pauseOverlay == nil else { return }

    pauseOverlay = PauseOverlay(size: size)
    pauseOverlay?.delegate = self
    pauseOverlay?.zPosition = 1000
    addChild(pauseOverlay!)
    pauseOverlay?.show()
  }

  private func hidePauseOverlay() {
    pauseOverlay?.hide()
    pauseOverlay?.removeFromParent()
    pauseOverlay = nil

    gameState.resumeGame()
  }

  // MARK: - PauseOverlayDelegate

  func didTapResume() {
    hidePauseOverlay()
  }

  func didTapBackHome() {
    hidePauseOverlay()
    gameState.resetGameState() // Reset the game state when going home
    SoundManager.sound.stopInGameMusic()
    SoundManager.sound.playLobbyMusic()
    SceneCoordinator.shared.transitionWithAnimation(to: .home)
  }
}
