//
//  TransitionController.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 19/07/25.
//

import Foundation
import SpriteKit

protocol TransitionControllerDelegate: AnyObject {
  func transitionDidCompleteToGameplay()
}

class TransitionController {
  // MARK: - Properties

  weak var delegate: TransitionControllerDelegate?
  weak var scene: SKScene?

  private let homeLayerManager: HomeLayerManager
  private let gameLayerManager: GameLayerManager

  // Countdown
  private var countdownNode: CountdownNode?

  // State
  private var isTransitioning = false

  // MARK: - Initialization

  init(homeLayerManager: HomeLayerManager, gameLayerManager: GameLayerManager) {
    self.homeLayerManager = homeLayerManager
    self.gameLayerManager = gameLayerManager
  }

  func setup(in scene: SKScene) {
    self.scene = scene
    setupCountdownNode()
  }

  private func setupCountdownNode() {
    guard let scene else { return }

    let centerPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    countdownNode = CountdownNode(position: centerPosition)

    if let countdown = countdownNode {
      scene.addChild(countdown)
    }

    print("⏰ TransitionController: Countdown node created")
  }

  // MARK: - Transition Orchestration

  func startTransition() {
    guard !isTransitioning else {
      print("⏰ TransitionController: Transition already in progress")
      return
    }

    isTransitioning = true
    print("🎬 TransitionController: Starting seamless transition...")

    // Step 1: Animate UI elements out
    animateUIOut()
  }

  private func animateUIOut() {
    print("🎬 Step 1: Animating UI out...")

    homeLayerManager.animateOut { [weak self] in
      // Step 2: Slide crab in
      self?.slideCrabIn()
    }
  }

  private func slideCrabIn() {
    print("🎬 Step 2: Sliding crab in...")

    gameLayerManager.createAndAnimateCrab { [weak self] in
      // Step 3: Start countdown
      self?.startCountdown()
    }
  }

  private func startCountdown() {
    print("🎬 Step 3: Starting countdown...")

    guard let countdown = countdownNode else {
      startGameplay()
      return
    }

    let countdownNumbers = ["3", "2", "1", "GO!"]
    var currentIndex = 0

    func showNextNumber() {
      guard currentIndex < countdownNumbers.count
      else {
        // Countdown finished - start the game!
        startGameplay()
        return
      }

      countdown.text = countdownNumbers[currentIndex]
      countdown.alpha = 0
      countdown.setScale(0.5)

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

      countdown.run(sequence) {
        currentIndex += 1
        showNextNumber()
      }

      print("⏰ TransitionController: Showing countdown: \(countdownNumbers[currentIndex])")
    }

    showNextNumber()
  }

  private func startGameplay() {
    print("🎬 Step 4: Starting gameplay...")

    // Hide countdown
    countdownNode?.removeFromParent()

    // Activate game layer
    gameLayerManager.activateGameplay()

    // Mark transition as complete
    isTransitioning = false

    // Notify delegate
    delegate?.transitionDidCompleteToGameplay()

    print("🎮 TransitionController: Transition complete - game is now active!")
  }

  // MARK: - State

  var isInProgress: Bool {
    isTransitioning
  }

  // MARK: - Cleanup

  func cleanup() {
    countdownNode?.removeFromParent()
    countdownNode = nil
    isTransitioning = false
    scene = nil
  }
}
