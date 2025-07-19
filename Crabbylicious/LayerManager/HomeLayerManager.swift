//
//  HomeLayerManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 19/07/25.
//

import Foundation
import SpriteKit

protocol HomeLayerManagerDelegate: AnyObject {
  func HomeLayerDidRequestTransition()
}

class HomeLayerManager: BaseLayerManager {
  // MARK: - Properties

  weak var delegate: HomeLayerManagerDelegate?

  private var titleNode: TitleNode?
  private var titleShadow: TitleNode?
  private var playButton: ButtonNode?
  private var topCloud: CloudNode?
  private var bottomCloud: CloudNode?

  // State
  private var isTransitioning = false
  private var isButtonPressed = false

  // MARK: - Template Method Implementation

  override func createNodes() {
    guard let scene else { return }

    // Create title and shadow
    titleNode = TitleNode(size: CGSize(width: 300, height: 300))
    titleNode?.zPosition = 10

    titleShadow = TitleNode(size: CGSize(width: 300, height: 300))
    titleShadow?.alpha = 0.5
    titleShadow?.zPosition = 9

    // Create clouds
    topCloud = CloudNode()
    topCloud?.zPosition = 5

    bottomCloud = CloudNode()
    bottomCloud?.zPosition = 5

    // Create play button (initially invisible)
    playButton = ButtonNode(imageName: "buttonPlay", size: scene.size, alpha: 0.0)
    playButton?.zPosition = 10

    print("🎮 HomeLayerManager: Nodes created")
  }

  override func positionNodes() {
    // Position title and shadow
    let titlePosition = CGPoint(x: gameArea.midX, y: gameArea.midY + 30)
    titleNode?.position = titlePosition
    titleShadow?.position = titlePosition

    // Position clouds
    topCloud?.position = CGPoint(
      x: gameArea.minX + 70 + (CloudNode.cloudSize.width / 2),
      y: gameArea.maxY - 55 - (CloudNode.cloudSize.height / 2)
    )

    bottomCloud?.position = CGPoint(
      x: gameArea.maxX - 70 - (CloudNode.cloudSize.width / 2),
      y: gameArea.maxY - 151 - (CloudNode.cloudSize.height / 2)
    )

    // Position play button
    playButton?.position = CGPoint(x: gameArea.midX, y: gameArea.midY + 70)

    print("🎮 HomeLayerManager: Nodes positioned")
  }

  override func addNodesToScene() {
    guard let scene else { return }

    for node in [titleNode, titleShadow, topCloud, bottomCloud, playButton] {
      if let node {
        scene.addChild(node)
      }
    }

    print("🎮 HomeLayerManager: Nodes added to scene")
  }

  override func removeAllNodes() {
    for node in [titleNode, titleShadow, topCloud, bottomCloud, playButton] {
      node?.removeFromParent()
    }

    titleNode = nil
    titleShadow = nil
    topCloud = nil
    bottomCloud = nil
    playButton = nil

    print("🎮 HomeLayerManager: Nodes removed")
  }

  // MARK: - Public Methods

  func startIntroAnimations() {
    guard let title = titleNode,
          let titleShadow,
          let playButton else { return }

    // Start title slide-in animation
    let titleFinalPosition = title.position
    title.slideIn(finalPosition: titleFinalPosition)
    titleShadow.slideInThenAnimate(finalPosition: titleFinalPosition)

    // Fade in play button after delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      playButton.fadeIn()
    }

    print("🎮 HomeLayerManager: Intro animations started")
  }

  func animateOut(completion: @escaping () -> Void) {
    guard !isTransitioning else { return }

    isTransitioning = true
    isActive = false

    let slideUpDistance: CGFloat = (scene?.size.height ?? 1000) + 200
    let duration: TimeInterval = 0.8

    // Create slide up action
    let slideUp = SKAction.moveBy(x: 0, y: slideUpDistance, duration: duration)
    slideUp.timingMode = .easeIn

    // Animate all UI elements
    let nodesToAnimate = [titleNode, titleShadow, playButton, topCloud, bottomCloud]
    var completedAnimations = 0
    let totalAnimations = nodesToAnimate.count

    for node in nodesToAnimate {
      node?.run(slideUp) {
        completedAnimations += 1
        if completedAnimations == totalAnimations {
          completion()
        }
      }
    }

    print("🎮 HomeLayerManager: Animating out...")
  }

  // MARK: - Touch Handling

  func handleTouchBegan(at location: CGPoint) -> Bool {
    guard isActive, !isTransitioning,
          let playButton
    else {
      return false
    }

    // Check if the touch location is actually within the play button bounds
    if playButton.contains(location) {
      // Button press
      playButton.handleButtonPressed(button: playButton)
      isButtonPressed = true
      print("🎮 UILayerManager: Play button pressed")
      return true // Consumed the touch
    }

    return false // Touch was not on the button, don't consume it
  }

  func handleTouchEnded(at location: CGPoint) -> Bool {
    guard isActive, !isTransitioning,
          let playButton
    else {
      return false
    }

    // Check if we have a button that was pressed and the touch ended on it
    if isButtonPressed, playButton.contains(location) {
      // Button release - trigger transition
      playButton.handleButtonReleased(button: playButton)
      isButtonPressed = false

      // Notify delegate to start transition
      delegate?.HomeLayerDidRequestTransition()
      print("🎮 UILayerManager: Play button released - requesting transition")
      return true // Consumed the touch
    } else if isButtonPressed {
      // Touch ended outside button - cancel the press
      playButton.handleButtonReleased(button: playButton)
      isButtonPressed = false
      print("🎮 UILayerManager: Play button press cancelled")
      return true // Still consumed since we were tracking this touch
    }

    return false // Touch was not related to our button
  }

  // MARK: - Touch State Management

  func handleTouchCancelled() {
    if isButtonPressed, let playButton {
      playButton.handleButtonReleased(button: playButton)
      isButtonPressed = false
      print("🎮 HomeLayerManager: Touch cancelled")
    }
  }
}
