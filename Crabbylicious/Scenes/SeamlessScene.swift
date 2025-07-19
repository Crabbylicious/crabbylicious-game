//
//  SeamlessScene.swift
//  Crabbylicious
//
//  Enhanced with seamless transition to ECS gameplay
//

import GameplayKit
import SpriteKit
import SwiftUI

class SeamlessScene: SKScene {
  let gameArea: CGRect

  // ECS Components (activated during transition)
  private let entityManager = EntityManager()
  private let playerInputSystem = PlayerInputSystem()
  private let fallingSystem = FallingSystem()
  private var lifetimeSystem: LifetimeSystem!

  // Game state
  private var isInGameMode = false
  private var lastUpdateTime: TimeInterval = 0
  private var crabEntity: CrabEntity!

  // UI Elements for transition
  private var title: TitleNode!
  private var titleShadow: TitleNode!
  private var playButton: ButtonNode!
  private var topCloud: CloudNode!
  private var bottomCloud: CloudNode!
  private var countdownLabel: SKLabelNode!

  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    super.init(size: size)

    // Setup ECS (but don't activate yet)
    setupECS()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupECS() {
    lifetimeSystem = LifetimeSystem(scene: self)
  }

  override func didMove(to _: SKView) {
    setupHomeScreen()
  }

  private func setupHomeScreen() {
    // Background and ground (these stay throughout)
    let background = BackgroundNode(size: size)
    background.zPosition = 0
    addChild(background)

    let ground = GroundNode(size: size)
    ground.zPosition = 1
    addChild(ground)

    // Title and shadow
    title = TitleNode(size: CGSize(width: 300, height: 300))
    let titleFinalPosition = CGPoint(x: gameArea.midX, y: gameArea.midY + 30)
    title.zPosition = 10
    addChild(title)

    titleShadow = TitleNode(size: CGSize(width: 300, height: 300))
    titleShadow.position = CGPoint(x: gameArea.midX, y: gameArea.midY + 30)
    titleShadow.alpha = 0.5
    titleShadow.zPosition = 9
    addChild(titleShadow)

    title.slideIn(finalPosition: titleFinalPosition)
    titleShadow.slideInThenAnimate(finalPosition: titleFinalPosition)

    // Clouds
    topCloud = CloudNode(position: CGPoint(
      x: gameArea.minX + 70 + (CloudNode.cloudSize.width / 2),
      y: gameArea.maxY - 55 - (CloudNode.cloudSize.height / 2)
    ))
    topCloud.zPosition = 5
    addChild(topCloud)

    bottomCloud = CloudNode(position: CGPoint(
      x: gameArea.maxX - 70 - (CloudNode.cloudSize.width / 2),
      y: gameArea.maxY - 151 - (CloudNode.cloudSize.height / 2)
    ))
    bottomCloud.zPosition = 5
    addChild(bottomCloud)

    // Play button
    playButton = ButtonNode(imageName: "buttonPlay", size: size, alpha: 0.0)
    playButton.position = CGPoint(x: gameArea.midX, y: gameArea.midY + 70)
    playButton.zPosition = 10
    addChild(playButton)

    // Countdown label (hidden initially)
    setupCountdownLabel()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      self.playButton.fadeIn()
    }
  }

  private func setupCountdownLabel() {
    countdownLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    countdownLabel.text = "3"
    countdownLabel.fontSize = 120
    countdownLabel.fontColor = .white
    countdownLabel.position = CGPoint(x: gameArea.midX, y: gameArea.midY)
    countdownLabel.zPosition = 15
    countdownLabel.alpha = 0

    addChild(countdownLabel)
  }

  // MARK: - Transition Animation

  private func startTransitionToGame() {
    print("🎮 Starting transition to game...")

    // 1. Slide all UI elements up and out
    animateUIElementsOut()

    // 2. After UI is gone, slide crab in from left
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
      self.slideCrabIn()
    }

    // 3. After crab is positioned, start countdown
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      self.startCountdown()
    }
  }

  private func animateUIElementsOut() {
    let slideUpDistance: CGFloat = size.height + 200
    let duration: TimeInterval = 0.8

    // Create slide up action
    let slideUp = SKAction.moveBy(x: 0, y: slideUpDistance, duration: duration)
    slideUp.timingMode = .easeIn

    // Animate all UI elements
    title.run(slideUp)
    titleShadow.run(slideUp)
    playButton.run(slideUp)
    topCloud.run(slideUp)
    bottomCloud.run(slideUp)
  }

  private func slideCrabIn() {
    print("🦀 Sliding crab in...")

    // Create crab entity but position it off-screen to the left
    let finalPosition = CGPoint(x: size.width / 2, y: size.height * 0.13)
    let startPosition = CGPoint(x: -200, y: finalPosition.y)

    crabEntity = CrabEntity(scene: self, position: startPosition, gameArea: gameArea)
    addEntity(crabEntity)

    // Animate crab sliding in
    guard let spriteComponent = crabEntity.component(ofType: SpriteComponent.self),
          let animationComponent = crabEntity.component(ofType: AnimationComponent.self) else { return }

    // Start walking animation during slide
    animationComponent.startWalkingAnimation()

    let slideIn = SKAction.move(to: finalPosition, duration: 0.7)
    slideIn.timingMode = .easeOut

    spriteComponent.node.run(slideIn) {
      // Stop walking animation when crab reaches position
      animationComponent.stopWalkingAnimation()
      print("🦀 Crab reached final position!")
    }
  }

  private func startCountdown() {
    print("⏰ Starting countdown...")

    let countdownNumbers = ["3", "2", "1", "GO!"]
    var currentIndex = 0

    func showNextNumber() {
      guard currentIndex < countdownNumbers.count else {
        // Countdown finished - start the game!
        startGameplay()
        return
      }

      countdownLabel.text = countdownNumbers[currentIndex]
      countdownLabel.alpha = 0
      countdownLabel.setScale(0.5)

      // Animate number appearing
      let fadeIn = SKAction.fadeIn(withDuration: 0.2)
      let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
      let appear = SKAction.group([fadeIn, scaleUp])

      // Hold for a moment
      let wait = SKAction.wait(forDuration: 0.6)

      // Animate number disappearing
      let fadeOut = SKAction.fadeOut(withDuration: 0.2)
      let scaleDown = SKAction.scale(to: 0.8, duration: 0.2)
      let disappear = SKAction.group([fadeOut, scaleDown])

      let sequence = SKAction.sequence([appear, wait, disappear])

      countdownLabel.run(sequence) {
        currentIndex += 1
        showNextNumber()
      }
    }

    showNextNumber()
  }

  private func startGameplay() {
    print("🎮 Game started!")

    // Hide countdown
    countdownLabel.removeFromParent()

    // Activate game mode
    isInGameMode = true

    // Reset game state
    GameState.shared.ingredientSpawnTimer = 0

    print("🎮 ECS systems now active!")
  }

  // MARK: - Game Update (ECS)

  override func update(_ currentTime: TimeInterval) {
    // Only run ECS systems when in game mode
    guard isInGameMode else { return }

    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }

    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    // Run ECS systems
    playerInputSystem.update(deltaTime: deltaTime, entityManager: entityManager)
    fallingSystem.update(deltaTime: deltaTime, entityManager: entityManager)
    lifetimeSystem.update(deltaTime: deltaTime, entityManager: entityManager)

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
    let randomIngredient = GameData.allIngredients.randomElement()!
    let spawnX = CGFloat.random(in: gameArea.minX ... gameArea.maxX)
    let spawnPosition = CGPoint(x: spawnX, y: size.height + 50)

    let ingredientEntity = IngredientEntity(scene: self, ingredient: randomIngredient, position: spawnPosition)
    addEntity(ingredientEntity)
    print("🥬 Spawned ingredient: \(randomIngredient.name)")
  }

  // MARK: - Entity Management

  func addEntity(_ entity: GKEntity) {
    entityManager.addEntity(entity)
  }

  func removeEntity(_ entity: GKEntity) {
    entityManager.removeEntity(entity)
  }

  // MARK: - Touch Handling

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = nodes(at: location)

    // Only handle UI touches when not in game mode
    if !isInGameMode {
      for node in nodes {
        if let buttonNode = node as? ButtonNode {
          buttonNode.handleButtonPressed(button: buttonNode)
        }
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = nodes(at: location)

    // Handle button release and transition
    if !isInGameMode {
      for node in nodes {
        if let buttonNode = node as? ButtonNode {
          buttonNode.handleButtonReleased(button: buttonNode)

          // Start transition when play button is released
          startTransitionToGame()
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    // Only handle crab movement when in game mode
    guard isInGameMode else { return }

    for touch in touches {
      let pointOfTouch = touch.location(in: self)
      let previousPointOfTouch = touch.previousLocation(in: self)
      let amountDragged = pointOfTouch.x - previousPointOfTouch.x

      playerInputSystem.handleTouchMoved(delta: amountDragged)
    }
  }
}
