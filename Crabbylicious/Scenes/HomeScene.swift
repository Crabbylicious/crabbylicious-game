//
//  HomeScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit
import SwiftUI

class HomeScene: SKScene {
  let gameArea: CGRect

  // Store references to animated nodes
  private var playButton: ButtonNode!
  private var title: TitleNode!
  private var titleShadow: TitleNode!
  private var topCloud: CloudNode!
  private var bottomCloud: CloudNode!

  // Animation timing constants - easily adjustable
  private let exitAnimationDuration: TimeInterval = 0.8
  private let buttonPressDelay: TimeInterval = 0.2
  private let sceneTransitionDelay: TimeInterval = 0.4 // When to start scene transition during exit

  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    super.init(size: size)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMove(to _: SKView) {
    let background = BackgroundNode(size: size)
    background.zPosition = 0
    addChild(background)

    let ground = GroundNode(size: size)
    ground.zPosition = 1
    addChild(ground)

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

    playButton = ButtonNode(imageName: "buttonPlay")
    playButton.position = CGPoint(x: gameArea.midX, y: gameArea.midY - 120)
    playButton.zPosition = 10
    addChild(playButton)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      self.playButton.fadeIn()
    }

    // Debug: Verify all nodes are properly initialized
    print("🟢 HomeScene nodes initialized:")
    print("   - title: \(title != nil ? "✓" : "✗")")
    print("   - titleShadow: \(titleShadow != nil ? "✓" : "✗")")
    print("   - topCloud: \(topCloud != nil ? "✓" : "✗")")
    print("   - bottomCloud: \(bottomCloud != nil ? "✓" : "✗")")
    print("   - playButton: \(playButton != nil ? "✓" : "✗")")
  }

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = nodes(at: location)

    for node in nodes {
      if let buttonNode = node as? ButtonNode {
        buttonNode.handleButtonPressed(button: buttonNode)
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = nodes(at: location)

    for node in nodes {
      if let buttonNode = node as? ButtonNode {
        buttonNode.handleButtonReleased(button: buttonNode)
      }
    }

    // Check if play button was tapped
    if playButton.contains(location) {
      startExitAnimationSequence()
    }
  }

  private func startExitAnimationSequence() {
    // Disable further touches
    isUserInteractionEnabled = false

    // Wait for button animation to complete, then start exit animations
    DispatchQueue.main.asyncAfter(deadline: .now() + buttonPressDelay) {
      self.animateNodesExit()
    }

    // Start scene transition partway through the exit animation
    DispatchQueue.main.asyncAfter(deadline: .now() + buttonPressDelay + sceneTransitionDelay) {
      self.transitionToGameScene()
    }
  }

  private func animateNodesExit() {
    let moveUpDistance: CGFloat = size.height + 200 // Move well above screen

    // Safety check - ensure all nodes exist before animating
    guard let title,
          let titleShadow,
          let topCloud,
          let bottomCloud
    else {
      print("❌ HomeScene: Some nodes are nil, skipping exit animation")
      // Still transition to game scene even if animation fails
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.transitionToGameScene()
      }
      return
    }

    // Calculate target positions (all move up by the same amount)
    let titleTarget = CGPoint(x: title.position.x, y: title.position.y + moveUpDistance)
    let titleShadowTarget = CGPoint(x: titleShadow.position.x, y: titleShadow.position.y + moveUpDistance)
    let topCloudTarget = CGPoint(x: topCloud.position.x, y: topCloud.position.y + moveUpDistance)
    let bottomCloudTarget = CGPoint(x: bottomCloud.position.x, y: bottomCloud.position.y + moveUpDistance)
    let buttonTarget = CGPoint(x: playButton.position.x, y: playButton.position.y + moveUpDistance)

    // Create move actions with easing
    let moveAction = SKAction.move(to: titleTarget, duration: exitAnimationDuration)
    moveAction.timingMode = .easeInEaseOut

    let shadowMoveAction = SKAction.move(to: titleShadowTarget, duration: exitAnimationDuration)
    shadowMoveAction.timingMode = .easeInEaseOut

    let topCloudMoveAction = SKAction.move(to: topCloudTarget, duration: exitAnimationDuration)
    topCloudMoveAction.timingMode = .easeInEaseOut

    let bottomCloudMoveAction = SKAction.move(to: bottomCloudTarget, duration: exitAnimationDuration)
    bottomCloudMoveAction.timingMode = .easeInEaseOut

    let buttonMoveAction = SKAction.move(to: buttonTarget, duration: exitAnimationDuration)
    buttonMoveAction.timingMode = .easeInEaseOut

    // Optional: Add slight delays for staggered effect
    let titleDelay = SKAction.wait(forDuration: 0.0)
    let cloudDelay = SKAction.wait(forDuration: 0.1)
    let buttonDelay = SKAction.wait(forDuration: 0.05)

    // Run animations
    title.run(SKAction.sequence([titleDelay, moveAction]))
    titleShadow.run(SKAction.sequence([titleDelay, shadowMoveAction]))
    topCloud.run(SKAction.sequence([cloudDelay, topCloudMoveAction]))
    bottomCloud.run(SKAction.sequence([cloudDelay, bottomCloudMoveAction]))
    playButton.run(SKAction.sequence([buttonDelay, buttonMoveAction]))
  }

  private func transitionToGameScene() {
    let screenSize = UIScreen.main.bounds.size
    let gameScene = GameScene(size: screenSize)

    // No fade transition since backgrounds match
    view?.presentScene(gameScene)
  }
}
