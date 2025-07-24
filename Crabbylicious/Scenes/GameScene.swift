//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, GameOverOverlayDelegate {
  // Entity Manager
  private let entityManager = EntityManager()

  // Component Systems
  private let playerInputSystem = PlayerInputSystem()
  private let fallingSystem = FallingSystem()
  private let bubbleBackgroundSystem = BubbleBackgroundSystem() // Tambahkan sistem baru

  // Game properties
  let gameArea: CGRect
  var recipeCard: RecipeCardNode!
  private var lastUpdateTime: TimeInterval = 0
  private var crabEntity: CrabEntity!
  private var recipeEntity: RecipeCardEntity!
  private var lifeDisplay: LifeDisplayNode!
  private var gameOverOverlay: GameOverOverlay!

  var catchingSystem: CatchingSystem!

  // Animation control
  private var gameStarted = false
  private var gameOverActive = false
  private var bubbleEntranceCompleted = false
  private let crabEntranceDuration: TimeInterval = 1.2
  private let gameStartDelay: TimeInterval = 0.3 // Delay before crab starts walking in

  // Countdown control
  private let countdownDuration: TimeInterval = 0.8 // How long each number shows
  private let countdownPause: TimeInterval = 0.2 // Pause after crab entrance before countdown

  private let wrongSound = SKAction.playSoundFileNamed("soundSalah.wav", waitForCompletion: false)

  override init(size: CGSize) {
    print("🟢 ECSGameScene: Initializing...")

    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    super.init(size: size)
    print("🟢 ECSGameScene: Super init completed")
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMove(to _: SKView) {
    // Set up physics world
    physicsWorld.contactDelegate = self

    // Set consistent gravity - no more dynamic changes
    physicsWorld.gravity = CGVector(dx: 0, dy: -2) // Nice, consistent falling speed

    print("🟢 ProperECSGameScene: didMove called")

    catchingSystem = CatchingSystem(gameState: GameState.shared, scene: self)

    // Add background and ground
    let background = BackgroundNode(size: size)
    addChild(background)

    let ground = GroundNode(size: size)
    addChild(ground)

    recipeEntity = RecipeCardEntity(
      scene: self,
      size: size,
      position: CGPoint(x: size.width / 2, y: size.height - 175)
    )

    addEntity(recipeEntity) // Optional if you want systems to query it
    recipeCard = recipeEntity.component(ofType: SpriteComponent.self)?.node as? RecipeCardNode

    // Life display
    lifeDisplay = LifeDisplayNode()
    lifeDisplay.zPosition = 10
    lifeDisplay.position = CGPoint(x: 100, y: size.height - 80)
    addChild(lifeDisplay)

    // Game Over Overlay (initially hidden)
    gameOverOverlay = GameOverOverlay(size: size)
    gameOverOverlay.delegate = self
    gameOverOverlay.zPosition = 1000 // High z-position to appear on top
    addChild(gameOverOverlay)

    // Set up bubble background starting from below
    setupBubbleBackground()

    // Test GameState
    let gameState = GameState.shared
    print("🟢 GameState recipe: \(gameState.currentRecipe.name)")

    // Create crab entity positioned OFF-SCREEN to the left
    let crabStartPosition = CGPoint(x: gameArea.minX - 100, y: size.height * 0.13)
    let crabFinalPosition = CGPoint(x: size.width / 2, y: size.height * 0.13)

    crabEntity = CrabEntity(scene: self, position: crabStartPosition, gameArea: gameArea)
    addEntity(crabEntity)

    // Disable player control during entrance
    if let playerControl = crabEntity.component(ofType: PlayerControlComponent.self) {
      playerControl.isControllable = false
    }

    print("🟢 Crab created off-screen, starting entrance animation...")

    // Start the entrance sequence
    startCrabEntranceAnimation(to: crabFinalPosition)
  }

  private func setupBubbleBackground() {
    let bubbleNode1 = BubbleBackgroundNode(size: size)
    let bubbleNode2 = BubbleBackgroundNode(size: size)
    bubbleNode1.zPosition = 0.5 // Between background (0) and ground (1)
    bubbleNode2.zPosition = 0.5

    // Start bubbles from below the screen for nice entrance effect
    let overlapY: CGFloat = 20.0
    bubbleNode1.position = CGPoint(x: size.width / 2, y: -bubbleNode1.size.height / 2)
    bubbleNode2.position = CGPoint(x: size.width / 2, y: bubbleNode1.position.y - bubbleNode1.size.height + overlapY)

    print("🟢 GameScene: Starting bubbles from below screen")
    print("   - Bubble 1: \(bubbleNode1.position)")
    print("   - Bubble 2: \(bubbleNode2.position)")

    addChild(bubbleNode1)
    addChild(bubbleNode2)

    // Create bubble entity and add to system
    let bubbleEntity = GKEntity()
    bubbleEntity.addComponent(BubbleBackgroundComponent(nodes: [bubbleNode1, bubbleNode2]))
    addEntity(bubbleEntity)

    // Start fast entrance animation to fill screen
    startBubbleEntranceAnimation(nodes: [bubbleNode1, bubbleNode2])
  }

  private func startBubbleEntranceAnimation(nodes: [BubbleBackgroundNode]) {
    print("🟢 Starting fast bubble entrance animation")

    // Calculate how much to move up to fill screen
    let fastMoveDistance: CGFloat = size.height + nodes[0].size.height

    // Fast entrance animation duration (same as crab entrance)
    let entranceDuration = crabEntranceDuration + gameStartDelay + countdownDuration + countdownPause

    for node in nodes {
      // Fast upward movement to fill screen
      let fastMoveUp = SKAction.moveBy(x: 0, y: fastMoveDistance, duration: entranceDuration)
      fastMoveUp.timingMode = .easeOut

      node.run(fastMoveUp) {
        print("🟢 Bubble fast entrance completed - switching to normal speed")
        // Mark that entrance is done (when first bubble completes)
        if node == nodes.first {
          self.bubbleEntranceCompleted = true
        }
      }
    }
  }

  private func startCountdownSequence() {
    print("🟢 Starting countdown sequence...")

    // Wait a moment after crab entrance, then start countdown
    DispatchQueue.main.asyncAfter(deadline: .now() + countdownPause) {
      self.showCountdownNumber(3)
    }
  }

  private func showCountdownNumber(_ number: Int) {
    print("🟢 Showing countdown: \(number)")

    // Create countdown node at center of screen
    let countdownPosition = CGPoint(x: size.width / 2, y: size.height / 2)
    let countdownNode = CountdownNode(number: number, position: countdownPosition)

    addChild(countdownNode)

    // Calculate pause duration (subtract animation time from total duration)
    let pauseDuration = countdownDuration - 0.6 // 0.6 = scaleIn + scaleOut duration

    // Animate the countdown number
    countdownNode.animateCountdown(pauseDuration: pauseDuration) {
      // When animation completes, show next number or start game
      if number > 1 {
        // Show next countdown number
        self.showCountdownNumber(number - 1)
      } else {
        // Countdown finished, start the game!
        self.startActualGame()
      }
    }
  }

  private func startActualGame() {
    print("🟢 Countdown finished - Game started!")
    gameStarted = true
    print("🟢 Game fully started - ingredients will now spawn")
  }

  private func startCrabEntranceAnimation(to finalPosition: CGPoint) {
    guard let spriteComponent = crabEntity.component(ofType: SpriteComponent.self),
          let animationComponent = crabEntity.component(ofType: AnimationComponent.self)
    else {
      print("❌ Missing components for crab entrance")
      return
    }

    // Wait a moment, then start the entrance
    DispatchQueue.main.asyncAfter(deadline: .now() + gameStartDelay) {
      // Start walking animation
      animationComponent.startWalkingAnimation()

      // Create move action
      let moveAction = SKAction.move(to: finalPosition, duration: self.crabEntranceDuration)
      moveAction.timingMode = .easeOut

      // Run the move action
      spriteComponent.node.run(moveAction) {
        // Animation completed
        print("🟢 Crab entrance completed!")

        // Stop walking animation
        animationComponent.stopWalkingAnimation()

        // Enable player control
        if let playerControl = self.crabEntity.component(ofType: PlayerControlComponent.self) {
          playerControl.isControllable = true
        }

        // Start countdown sequence
        self.startCountdownSequence()
      }
    }
  }

  override func update(_ currentTime: TimeInterval) {
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }

    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    bubbleBackgroundSystem
      .update(deltaTime: deltaTime, entityManager: entityManager, sceneSize: size) // update animasi bubble background

    guard gameStarted else { return } // Don't respond to touches during entrance and countdown

    // Systems query entities automatically
    playerInputSystem.update(deltaTime: deltaTime, entityManager: entityManager)

    // Only update falling system and ingredient spawning if game over is not active
    if !gameOverActive {
      fallingSystem.update(deltaTime: deltaTime, entityManager: entityManager)

      // Handle ingredient spawning
      updateIngredientSpawning(deltaTime: deltaTime)
    }

    // Cleanup ingredients (always run to clean up any remaining ingredients)
    cleanupOffscreenIngredients()
  }

  private func cleanupOffscreenIngredients() {
    let ingredientEntities = entityManager.getEntitiesWith(componentType: IngredientComponent.self)
    var entitiesToRemove: [GKEntity] = []

    for entity in ingredientEntities {
      guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else { continue }

      let position = spriteComponent.node.position

      // Simple bounds check - if below screen or too far to sides, remove it
      if position.y < -100 ||
        position.x < gameArea.minX - 100 ||
        position.x > gameArea.maxX + 100
      {
        entitiesToRemove.append(entity)
      }
    }

    // Remove offscreen entities
    for entity in entitiesToRemove {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        spriteComponent.node.removeFromParent()
      }
      removeEntity(entity)
    }
  }

  private func updateIngredientSpawning(deltaTime: TimeInterval) {
    // Don't spawn ingredients if game over overlay is active
    guard !gameOverActive else { return }

    let gameState = GameState.shared
    gameState.ingredientSpawnTimer += deltaTime

    // Use dynamic spawn interval based on difficulty and progress
    let currentSpawnInterval = gameState.getCurrentSpawnInterval()

    if gameState.ingredientSpawnTimer >= currentSpawnInterval {
      spawnRandomIngredient()
      gameState.ingredientSpawnTimer = 0
    }
  }

  private func spawnRandomIngredient() {
    // Use smart ingredient selection instead of pure random
    let smartIngredient = GameState.shared.selectSmartIngredient()
    let spawnX = CGFloat.random(in: gameArea.minX + 50 ... gameArea.maxX - 50)
    let spawnPosition = CGPoint(x: spawnX, y: size.height + 50)

    let ingredientEntity = IngredientEntity(scene: self, ingredient: smartIngredient, position: spawnPosition)

    // Simply add entity - systems will find it automatically!
    addEntity(ingredientEntity)
    print("🟢 Spawned smart ingredient: \(smartIngredient.name)")
  }

  // MARK: - Entity Management (Clean!)

  func addEntity(_ entity: GKEntity) {
    print("🟢 Adding entity to EntityManager...")
    entityManager.addEntity(entity)
    print("🟢 Entity added - systems will find it automatically!")
  }

  func removeEntity(_ entity: GKEntity) {
    print("🟢 Removing entity from EntityManager...")
    entityManager.removeEntity(entity)
  }

  // MARK: - Touch Handling

  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard gameStarted else { return } // Don't respond to touches during entrance

    for touch in touches {
      let pointOfTouch = touch.location(in: self)
      let previousPointOfTouch = touch.previousLocation(in: self)
      let amountDragged = pointOfTouch.x - previousPointOfTouch.x

      playerInputSystem.handleTouchMoved(delta: amountDragged)
    }
  }

  override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
    guard gameStarted else { return } // Don't respond to touches during entrance

    playerInputSystem.handleTouchEnded()
  }

  // MARK: - Physics Contact Handling

  func didBegin(_ contact: SKPhysicsContact) {
    guard gameStarted else { return } // Don't respond to touches during entrance

    var ingredientEntity: GKEntity?
    var basketEntity: GKEntity?

    // Find which bodies are ingredient and basket
    if contact.bodyA.categoryBitMask == PhysicsCategory.ingredient {
      ingredientEntity = findEntityForNode(contact.bodyA.node)
      basketEntity = findEntityForNode(contact.bodyB.node)
    } else if contact.bodyB.categoryBitMask == PhysicsCategory.ingredient {
      ingredientEntity = findEntityForNode(contact.bodyB.node)
      basketEntity = findEntityForNode(contact.bodyA.node)
    }

    // just for top area
    if let ingredient = ingredientEntity, let basket = basketEntity {
      guard let ingredientNode = ingredient.component(ofType: SpriteComponent.self)?.node,
            let crabNode = basket.component(ofType: SpriteComponent.self)?.node else { return }

      let crabTopY = crabNode.frame.maxY
      let crabTopAreaY = crabTopY - crabNode.frame.height * 0.2 // area top 20%
      let ingredientCenterY = ingredientNode.position.y

      if ingredientCenterY >= crabTopAreaY {
        handleIngredientCaught(ingredient)
      }
    }
  }

  private func findEntityForNode(_ node: SKNode?) -> GKEntity? {
    // Helper method to find entity associated with a sprite node
    let allEntities = entityManager.getAllEntities()
    for entity in allEntities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self),
         spriteComponent.node == node
      {
        return entity
      }
    }
    return nil
  }

  private func handleIngredientCaught(_ entity: GKEntity) {
    guard let ingredientComponent = entity.component(ofType: IngredientComponent.self),
          let spriteComponent = entity.component(ofType: SpriteComponent.self)
    else {
      return
    }

    let ingredient = ingredientComponent.ingredient
    let spriteNode = spriteComponent.node

    // Absurd (non-recipe) ingredient
    if ingredient.isAbsurd {
      print("Game Over - Caught absurd ingredient!")
      // Handle game over
      showWrongIndicator(at: spriteNode.position)
      removeEntity(entity)
      spriteNode.removeFromParent()
      return
    }

    // Recipe logic
    let recipe = GameState.shared.currentRecipe
    let requiredAmount = recipe.ingredients.first(where: { $0.0 == ingredient })?.1 ?? 0
    let currentAmount = GameState.shared.collectedIngredients[ingredient] ?? 0

    print("🐛 DEBUG - Ingredient: \(ingredient.name)")
    print("🐛 DEBUG - Required: \(requiredAmount), Current: \(currentAmount)")

    if requiredAmount > 0, currentAmount < requiredAmount {
      // ✅ Correct and still needed
      GameState.shared.addCollectedIngredient(ingredient)
      recipeCard.updateRecipeDisplay()
      print(" 👀 Right ingredient caught!")

      spriteNode.removeFromParent()
      removeEntity(entity)

      // Optional: Correct indicator animation
      showCorrectIndicator(on: spriteNode)

      if GameState.shared.isRecipeComplete() {
        print("Collected: \(GameState.shared.collectedIngredients)")
        print("Current Recipe: \(GameState.shared.currentRecipe.ingredients)")

        print("Recipe Complete!")
        handleRecipeComplete()
      }

    } else {
      // ❌ Wrong: either not in recipe or already fulfilled
      print(" 👀 Wrong ingredient caught!")
      showWrongIndicator(at: spriteNode.position)

      // Remove the ingredient visually
      spriteNode.removeFromParent()
      removeEntity(entity)
    }
  }

  func showNextStage() {
    let overlay = NextStageOverlay(recipe: GameState.shared.currentRecipe, gameScene: self)
    overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
    overlay.zPosition = 999
    addChild(overlay)

    isPaused = true // Optional if you want to pause gameplay
  }

  // Add this method to handle next stage transition
  func proceedToNextStage() {
    print("🟢 GameScene: Proceeding to next stage...")

    // Debug current state before transition
    recipeCard?.debugCurrentState()

    // Move to next recipe and reset ingredients
    GameState.shared.moveToNextRecipe()
    print("🔍 DEBUG: New recipe in GameScene: \(GameState.shared.currentRecipe.name)")
    print("🔍 DEBUG: Collected ingredients after reset: \(GameState.shared.collectedIngredients)")

    // Force refresh the recipe card display
    if let recipeCard {
      print("🔍 DEBUG: Force refreshing recipe card from GameScene...")
      recipeCard.forceRefreshDisplay()

      // Debug state after refresh
      recipeCard.debugCurrentState()

      print("🔍 DEBUG: Recipe card force refreshed")
    } else {
      print("❌ ERROR: Recipe card is nil in GameScene!")
    }

    // Resume the game
    isPaused = false

    print("🟢 GameScene: Next stage transition completed")
  }

  private func handleRecipeComplete() {
    showNextStage()
    lifeDisplay.updateHeartDisplay() // Update hearts when lives are reset
  }

  private func handleGameOver() {
    print("💀 Game Over! No lives remaining.")

    // Set game over flag to stop ingredient spawning
    gameOverActive = true

    // Disable player input
    if let playerControl = crabEntity.component(ofType: PlayerControlComponent.self) {
      playerControl.isControllable = false
    }

    // Show game over overlay
    gameOverOverlay.show()
  }

  // Public method for CatchingSystem to call
  func updateLifeDisplay() {
    lifeDisplay.updateHeartDisplay()
  }

  // Public method for CatchingSystem to handle game over
  func handleGameOverFromSystem() {
    handleGameOver()
  }

  private func showWrongIndicator(at position: CGPoint) {
    let xMark = SKSpriteNode(imageNamed: "x_mark")
    xMark.position = position
    xMark.zPosition = 500
    addChild(xMark)

    HapticManager.haptic.playFailureHaptic()

    // Decrease life and update display
    GameState.shared.decreaseLife()
    lifeDisplay.animateLifeLoss()

    // Check for game over
    if GameState.shared.isGameOver() {
      handleGameOver()
    }

    xMark.run(SKAction.sequence([
      wrongSound,
      SKAction.fadeOut(withDuration: 0.6),
      SKAction.removeFromParent()
    ]))
  }

  private func showCorrectIndicator(on node: SKNode) {
    HapticManager.haptic.playSuccessHaptic()
    SoundManager.sound.playCorrectSound()

    node.run(SKAction.sequence([
      SKAction.scale(to: 1.2, duration: 0.1),
      SKAction.scale(to: 1.0, duration: 0.1)
    ]))
  }

  // MARK: - GameOverOverlayDelegate

  func didTapPlayAgain() {
    print("🔄 Play Again tapped")

    // Hide overlay
    gameOverOverlay.hide()

    // Reset game over flag to resume ingredient spawning
    gameOverActive = false

    // Reset game state
    GameState.shared.resetGame()

    // Update UI
    recipeCard.updateRecipeDisplay()
    lifeDisplay.updateHeartDisplay()

    // Re-enable player control
    if let playerControl = crabEntity.component(ofType: PlayerControlComponent.self) {
      playerControl.isControllable = true
    }

    // Clear any remaining ingredients from screen
    clearAllIngredients()

    print("✅ Game restarted successfully")
  }

  func didTapBackHome() {
    print("🏠 Back Home tapped")

    // Hide overlay first
    gameOverOverlay.hide()

    // Reset game state for next play session
    GameState.shared.resetGame()

    // Reset game over flag
    gameOverActive = false

    // Clear any remaining ingredients from screen
    clearAllIngredients()

    // Transition to HomeScene with a slight delay for overlay to fade out
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.transitionToHomeScene()
    }
  }

  private func transitionToHomeScene() {
    print("🏠 Transitioning to HomeScene...")

    // Ensure game is fully paused during transition
    gameStarted = false
    isPaused = true

    let homeScene = HomeScene(size: size)

    // Use a fade transition for smooth experience
    let transition = SKTransition.fade(withDuration: 0.5)
    view?.presentScene(homeScene, transition: transition)

    print("✅ Successfully transitioned to HomeScene")
  }

  // Helper method to clear all ingredients from screen
  private func clearAllIngredients() {
    let ingredientEntities = entityManager.getEntitiesWith(componentType: IngredientComponent.self)

    for entity in ingredientEntities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        spriteComponent.node.removeFromParent()
      }
      removeEntity(entity)
    }
  }
}
