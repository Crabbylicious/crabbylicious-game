//
//  GameLayerManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 19/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

protocol GameLayerManagerDelegate: AnyObject {
  func gameLayerDidFinishCrabEntrance()
}

class GameLayerManager: BaseLayerManager {
  // MARK: - Properties

  weak var delegate: GameLayerManagerDelegate?

  // ECS Components
  private let entityManager = EntityManager()
  private let playerInputSystem = PlayerInputSystem()
  private let fallingSystem = FallingSystem()
  private var lifetimeSystem: LifetimeSystem!

  // Game entities
  private var crabEntity: CrabEntity?

  // State
  private var isGameActive = false
  private var isECSSetup = false

  // MARK: - Template Method Implementation

  override func createNodes() {
    // GameLayer doesn't create nodes immediately
    // Nodes are created during crab entrance animation
    print("🦀 GameLayerManager: Ready to create nodes")
  }

  override func positionNodes() {
    // Positioning handled during createCrab()
    print("🦀 GameLayerManager: Ready to position nodes")
  }

  override func addNodesToScene() {
    // Nodes added during createCrab()
    print("🦀 GameLayerManager: Ready to add nodes")
  }

  override func removeAllNodes() {
    // Remove all entities and their sprite nodes
    let allEntities = entityManager.getAllEntities()
    for entity in allEntities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        spriteComponent.node.removeFromParent()
      }
    }

    // Clear entity manager
    for entity in allEntities {
      entityManager.removeEntity(entity)
    }

    crabEntity = nil
    isGameActive = false

    print("🦀 GameLayerManager: All game nodes removed")
  }

  // MARK: - Setup

  override func setup(in scene: SKScene, gameArea: CGRect) {
    super.setup(in: scene, gameArea: gameArea)
    setupECS()
  }

  private func setupECS() {
    guard !isECSSetup else { return }

    // Initialize lifetime system with scene reference
    if let seamlessScene = scene as? SeamlessScene {
      lifetimeSystem = LifetimeSystem(scene: seamlessScene)
    }

    isECSSetup = true
    print("🦀 GameLayerManager: ECS systems initialized")
  }

  // MARK: - Game Activation

  func createAndAnimateCrab(completion: @escaping () -> Void) {
    guard let scene else { return }

    // Create crab entity off-screen to the left
    let finalPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.13)
    let startPosition = CGPoint(x: -200, y: finalPosition.y)

    crabEntity = CrabEntity(scene: scene, position: startPosition, gameArea: gameArea)
    addEntity(crabEntity!)

    // Animate crab sliding in
    guard let spriteComponent = crabEntity?.component(ofType: SpriteComponent.self),
          let animationComponent = crabEntity?.component(ofType: AnimationComponent.self)
    else {
      completion()
      return
    }

    // Start walking animation during slide
    animationComponent.startWalkingAnimation()

    let slideIn = SKAction.move(to: finalPosition, duration: 0.7)
    slideIn.timingMode = .easeOut

    spriteComponent.node.run(slideIn) { [weak self] in
      // Stop walking animation when crab reaches position
      animationComponent.stopWalkingAnimation()
      print("🦀 GameLayerManager: Crab reached final position!")

      // Notify delegate that crab entrance is complete
      self?.delegate?.gameLayerDidFinishCrabEntrance()
      completion()
    }

    print("🦀 GameLayerManager: Crab slide-in animation started")
  }

  func activateGameplay() {
    isGameActive = true
    isActive = true

    // Reset game state
    GameState.shared.ingredientSpawnTimer = 0

    print("🦀 GameLayerManager: Gameplay activated!")
  }

  func deactivateGameplay() {
    isGameActive = false
    print("🦀 GameLayerManager: Gameplay deactivated")
  }

  // MARK: - Update Loop

  override func update(deltaTime: TimeInterval) {
    guard isGameActive, isECSSetup else { return }

    // Run ECS systems
    playerInputSystem.update(deltaTime: deltaTime, entityManager: entityManager)
    fallingSystem.update(deltaTime: deltaTime, entityManager: entityManager)
    lifetimeSystem?.update(deltaTime: deltaTime, entityManager: entityManager)

    // Handle ingredient spawning
    updateIngredientSpawning(deltaTime: deltaTime)
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
    guard let scene else { return }

    let randomIngredient = GameData.allIngredients.randomElement()!
    let spawnX = CGFloat.random(in: gameArea.minX ... gameArea.maxX)
    let spawnPosition = CGPoint(x: spawnX, y: scene.size.height + 50)

    let ingredientEntity = IngredientEntity(
      scene: scene,
      ingredient: randomIngredient,
      position: spawnPosition
    )
    addEntity(ingredientEntity)

    print("🥬 GameLayerManager: Spawned ingredient: \(randomIngredient.name)")
  }

  // MARK: - Entity Management

  func addEntity(_ entity: GKEntity) {
    entityManager.addEntity(entity)
  }

  func removeEntity(_ entity: GKEntity) {
    entityManager.removeEntity(entity)
  }

  func handleCrabMovement(delta: CGFloat) {
    guard isGameActive else { return }
    playerInputSystem.handleTouchMoved(delta: delta)
  }

  func handleTouchEnded() {
    guard isGameActive else { return }
    playerInputSystem.handleTouchEnded()
  }
}
