////
////  ECSGameScene.swift
////  Crabbylicious
////
////  Created by Java Kanaya Prada on 18/07/25.
////
//
// import Foundation
// import GameplayKit
// import SpriteKit
//
// class ECSGameScene: SKScene {
//  // Entity Manager
//  private let entityManager = EntityManager()
//
//  // Component Systems
//  private let playerInputSystem = PlayerInputSystem()
//  private let fallingSystem = FallingSystem()
//  private var lifetimeSystem: LifetimeSystem!
//
//  // Game properties
//  let gameArea: CGRect
//  private var lastUpdateTime: TimeInterval = 0
//  private var crabEntity: CrabEntity!
//
//  override init(size: CGSize) {
//    print("🟢 ECSGameScene: Initializing...")
//
//    let maxAspectRatio: CGFloat = 16.0 / 9.0
//    let playableWidth = size.height / maxAspectRatio
//    let margin = (size.width - playableWidth) / 2
//    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
//
//    super.init(size: size)
//    print("🟢 ECSGameScene: Super init completed")
//
//    setupECS()
//  }
//
//  @available(*, unavailable)
//  required init?(coder _: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  private func setupECS() {
//    print("🟢 ECSGameScene: Setting up proper ECS...")
//    lifetimeSystem = LifetimeSystem(scene: self)
//    print("🟢 All systems created")
//  }
//
//  override func didMove(to _: SKView) {
//    print("🟢 ProperECSGameScene: didMove called")
//
//    // Add background and ground
//    let background = BackgroundNode(size: size)
//    addChild(background)
//
//    let ground = GroundNode(size: size)
//    addChild(ground)
//
//    // Test GameState
//    let gameState = GameState.shared
//    print("🟢 GameState recipe: \(gameState.currentRecipe.name)")
//
//    // Create crab entity
//    let crabPosition = CGPoint(x: size.width / 2, y: size.height * 0.13)
//    crabEntity = CrabEntity(scene: self, position: crabPosition, gameArea: gameArea)
//
//    // Simply add entity - no manual system registration needed!
//    addEntity(crabEntity)
//    print("🟢 Crab created and added successfully!")
//  }
//
//  override func update(_ currentTime: TimeInterval) {
//    if lastUpdateTime == 0 {
//      lastUpdateTime = currentTime
//    }
//
//    let deltaTime = currentTime - lastUpdateTime
//    lastUpdateTime = currentTime
//
//    // Systems query entities automatically
//    playerInputSystem.update(deltaTime: deltaTime, entityManager: entityManager)
//    fallingSystem.update(deltaTime: deltaTime, entityManager: entityManager)
//    lifetimeSystem.update(deltaTime: deltaTime, entityManager: entityManager)
//
//    // Handle ingredient spawning
//    updateIngredientSpawning(deltaTime: deltaTime)
//  }
//
//  private func updateIngredientSpawning(deltaTime: TimeInterval) {
//    let gameState = GameState.shared
//    gameState.ingredientSpawnTimer += deltaTime
//
//    if gameState.ingredientSpawnTimer >= gameState.ingredientSpawnInterval {
//      spawnRandomIngredient()
//      gameState.ingredientSpawnTimer = 0
//    }
//  }
//
//  private func spawnRandomIngredient() {
//    let randomIngredient = GameData.allIngredients.randomElement()!
//    let spawnX = CGFloat.random(in: gameArea.minX ... gameArea.maxX)
//    let spawnPosition = CGPoint(x: spawnX, y: size.height + 50)
//
//    let ingredientEntity = IngredientEntity(scene: self, ingredient: randomIngredient, position: spawnPosition)
//
//    // Simply add entity - systems will find it automatically!
//    addEntity(ingredientEntity)
//    print("🟢 Spawned ingredient: \(randomIngredient.name)")
//  }
//
//  // MARK: - Entity Management (Clean!)
//
//  func addEntity(_ entity: GKEntity) {
//    print("🟢 Adding entity to EntityManager...")
//    entityManager.addEntity(entity)
//    print("🟢 Entity added - systems will find it automatically!")
//  }
//
//  func removeEntity(_ entity: GKEntity) {
//    print("🟢 Removing entity from EntityManager...")
//    entityManager.removeEntity(entity)
//  }
//
//  // MARK: - Touch Handling
//
//  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
//    for touch in touches {
//      let pointOfTouch = touch.location(in: self)
//      let previousPointOfTouch = touch.previousLocation(in: self)
//      let amountDragged = pointOfTouch.x - previousPointOfTouch.x
//
//      playerInputSystem.handleTouchMoved(delta: amountDragged)
//    }
//  }
//
//  override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
//    playerInputSystem.handleTouchEnded()
//  }
// }
