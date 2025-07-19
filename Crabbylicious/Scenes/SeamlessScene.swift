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
  // MARK: - Properties

  let gameArea: CGRect

  // Layer Managers
  private let backgroundLayerManager = BackgroundLayerManager()
  private let homeLayerManager = HomeLayerManager()
  private let gameLayerManager = GameLayerManager()
  private var transitionController: TransitionController!

  // State
  private var isInGameMode = false
  private var lastUpdateTime: TimeInterval = 0

  // MARK: - Initialization

  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    super.init(size: size)

    setupManagers()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupManagers() {
    // Setup delegates
    homeLayerManager.delegate = self
    gameLayerManager.delegate = self

    // Create transition controller
    transitionController = TransitionController(
      homeLayerManager: homeLayerManager,
      gameLayerManager: gameLayerManager
    )
    transitionController.delegate = self

    print("🏠 SeamlessScene: Managers setup complete")
  }

  // MARK: - Scene Lifecycle

  override func didMove(to _: SKView) {
    print("🏠 SeamlessScene: didMove called")
    setupLayers()
  }

  private func setupLayers() {
    // Setup all layers in order
    backgroundLayerManager.setup(in: self, gameArea: gameArea)
    homeLayerManager.setup(in: self, gameArea: gameArea)
    gameLayerManager.setup(in: self, gameArea: gameArea)
    transitionController.setup(in: self)

    // Start UI intro animations
    homeLayerManager.startIntroAnimations()

    print("🏠 SeamlessScene: All layers setup complete")
  }

  // MARK: - Update Loop

  override func update(_ currentTime: TimeInterval) {
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }

    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    // Update active layers
    backgroundLayerManager.update(deltaTime: deltaTime)
    homeLayerManager.update(deltaTime: deltaTime)
    gameLayerManager.update(deltaTime: deltaTime)
  }

  // MARK: - Touch Handling

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Only handle touch began for UI elements when not in game mode
    if !isInGameMode {
      _ = homeLayerManager.handleTouchBegan(at: location)
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)

    // Handle UI touch releases
    if homeLayerManager.handleTouchEnded(at: location) {
      return // UI layer handled it
    }

    // Handle game touch releases
    if isInGameMode {
      gameLayerManager.handleTouchEnded()
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    // Only handle crab movement when in game mode
    guard isInGameMode else { return }

    for touch in touches {
      let pointOfTouch = touch.location(in: self)
      let previousPointOfTouch = touch.previousLocation(in: self)
      let amountDragged = pointOfTouch.x - previousPointOfTouch.x

      gameLayerManager.handleCrabMovement(delta: amountDragged)
    }
  }

  override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
    // Handle cancelled touches
    homeLayerManager.handleTouchCancelled()

    if isInGameMode {
      gameLayerManager.handleTouchEnded()
    }
  }

  // MARK: - Entity Management (Public API for ECS)

  func addEntity(_ entity: GKEntity) {
    gameLayerManager.addEntity(entity)
  }

  func removeEntity(_ entity: GKEntity) {
    gameLayerManager.removeEntity(entity)
  }
}

// MARK: - UILayerManagerDelegate

extension SeamlessScene: HomeLayerManagerDelegate {
  func HomeLayerDidRequestTransition() {
    print("🏠 SeamlessScene: Home layer requested transition")
    transitionController.startTransition()
  }
}

// MARK: - GameLayerManagerDelegate

extension SeamlessScene: GameLayerManagerDelegate {
  func gameLayerDidFinishCrabEntrance() {
    print("🏠 SeamlessScene: Crab entrance finished")
    // Additional logic can be added here if needed
  }
}

// MARK: - TransitionControllerDelegate

extension SeamlessScene: TransitionControllerDelegate {
  func transitionDidCompleteToGameplay() {
    print("🏠 SeamlessScene: Transition to gameplay complete")
    isInGameMode = true
  }
}
