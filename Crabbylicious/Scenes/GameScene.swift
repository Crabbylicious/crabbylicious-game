//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  // Entity Manager
  private let entityManager = EntityManager()

  // Component Systems
  private let playerInputSystem = PlayerInputSystem()
  private let fallingSystem = FallingSystem()
  private let bubbleBackgroundSystem = BubbleBackgroundSystem() // Tambahkan sistem baru

  // Game properties
  let gameArea: CGRect
  private var lastUpdateTime: TimeInterval = 0
  private var crabEntity: CrabEntity!
  private var recipeCard: RecipeCardNode!
  private var recipeEntity: RecipeCardEntity!
  
  var catchingSystem: CatchingSystem!

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
    // Set up physics world (this replaces your custom gravity!)
    physicsWorld.contactDelegate = self

    // Base gravity that scales with difficulty
    let baseGravity: CGFloat = -2.0 // Negative for downward
    let difficultyGravity = baseGravity * CGFloat(GameState.shared.difficultyMultiplier)
    physicsWorld.gravity = CGVector(dx: 0, dy: difficultyGravity)

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
    self.recipeCard = recipeEntity.component(ofType: SpriteComponent.self)?.node as? RecipeCardNode

    let bubbleNode1 = BubbleBackgroundNode(size: size)
    let bubbleNode2 = BubbleBackgroundNode(size: size)
    bubbleNode1.zPosition = 1
    bubbleNode2.zPosition = 1

    // Posisi bubble pertama
    bubbleNode1.position = CGPoint(x: size.width / 2, y: size.height / 2)

    // Posisi bubble ke dua
    let overlapY: CGFloat = 20.0
    bubbleNode2.position = CGPoint(x: size.width / 2, y: bubbleNode1.position.y - bubbleNode1.size.height + overlapY)
    addChild(bubbleNode1)
    addChild(bubbleNode2)
    let bubbleEntity = GKEntity()
    bubbleEntity.addComponent(BubbleBackgroundComponent(nodes: [bubbleNode1, bubbleNode2]))
    addEntity(bubbleEntity)

    // Test GameState
    let gameState = GameState.shared
    print("🟢 GameState recipe: \(gameState.currentRecipe.name)")

    // Create crab entity
    let crabPosition = CGPoint(x: size.width / 2, y: size.height * 0.13)
    crabEntity = CrabEntity(scene: self, position: crabPosition, gameArea: gameArea)

    // Simply add entity - no manual system registration needed!
    addEntity(crabEntity)
    print("🟢 Crab created and added successfully!")
  }

  override func update(_ currentTime: TimeInterval) {
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }

    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    // Systems query entities automatically
    playerInputSystem.update(deltaTime: deltaTime, entityManager: entityManager)
    fallingSystem.update(deltaTime: deltaTime, entityManager: entityManager)
    bubbleBackgroundSystem
      .update(deltaTime: deltaTime, entityManager: entityManager, sceneSize: size) // update animasi bubble background

    // Cleanup ingredients
    cleanupOffscreenIngredients()

    // Handle ingredient spawning
    updateIngredientSpawning(deltaTime: deltaTime)
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
    let gameState = GameState.shared
    gameState.ingredientSpawnTimer += deltaTime

    if gameState.ingredientSpawnTimer >= gameState.ingredientSpawnInterval {
      spawnRandomIngredient()
      gameState.ingredientSpawnTimer = 0
    }
  }

  private func spawnRandomIngredient() {
    let randomIngredient = GameData.allIngredients.randomElement()!
    let spawnX = CGFloat.random(in: gameArea.minX + 50 ... gameArea.maxX - 50)
    let spawnPosition = CGPoint(x: spawnX, y: size.height + 50)

    let ingredientEntity = IngredientEntity(scene: self, ingredient: randomIngredient, position: spawnPosition)

    // Simply add entity - systems will find it automatically!
    addEntity(ingredientEntity)
    print("🟢 Spawned ingredient: \(randomIngredient.name)")
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
    for touch in touches {
      let pointOfTouch = touch.location(in: self)
      let previousPointOfTouch = touch.previousLocation(in: self)
      let amountDragged = pointOfTouch.x - previousPointOfTouch.x

      playerInputSystem.handleTouchMoved(delta: amountDragged)
    }
  }

  override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
    playerInputSystem.handleTouchEnded()
  }

  // MARK: - Physics Contact Handling

  func didBegin(_ contact: SKPhysicsContact) {
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
          let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
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

    if requiredAmount > 0 && currentAmount < requiredAmount {
        // ✅ Correct and still needed
        GameState.shared.addCollectedIngredient(ingredient)
        recipeCard.updateRecipeDisplay()
        print(" 👀 Right ingredient caught!")
      
        spriteNode.removeFromParent()
        removeEntity(entity)

        // Optional: Correct indicator animation
        showCorrectIndicator(on: spriteNode)

        if GameState.shared.isRecipeComplete() {
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

  private func handleRecipeComplete() {
    GameState.shared.moveToNextRecipe()
    recipeCard.updateRecipeDisplay()
  }
  
  private func showWrongIndicator(at position: CGPoint) {
    let xMark = SKSpriteNode(imageNamed: "x_mark")
    xMark.position = position
    xMark.zPosition = 500
    addChild(xMark)
    
    xMark.run(SKAction.sequence([
      SKAction.fadeOut(withDuration: 0.6),
      SKAction.removeFromParent()
    ]))
  }

  private func showCorrectIndicator(on node: SKNode) {
    node.run(SKAction.sequence([
      SKAction.scale(to: 1.2, duration: 0.1),
      SKAction.scale(to: 1.0, duration: 0.1)
    ]))
  }

  
  // Method to update difficulty during gameplay
  func updateDifficulty() {
    let newGravity = -400.0 * CGFloat(GameState.shared.difficultyMultiplier)
    physicsWorld.gravity = CGVector(dx: 0, dy: newGravity)
  }
}
