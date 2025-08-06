//
//  AnimationComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class AnimationComponent: GKComponent {
  private let legNode: SKSpriteNode
  private let legTextures: [SKTexture]
  private let walkAnimationKey = "walkAnimation"
  private let blinkAnimationKey = "blinkAnimation"

  // Reference to the main crab node for blinking animation - strong reference like legNode
  private let crabNode: SKSpriteNode?

  init(legNode: SKSpriteNode, legTextures: [SKTexture], crabNode: SKSpriteNode? = nil) {
    self.legNode = legNode
    self.legTextures = legTextures
    self.crabNode = crabNode
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startWalkingAnimation() {
    guard legNode.action(forKey: walkAnimationKey) == nil else { return }
    let animation = SKAction.repeatForever(
      SKAction.animate(with: legTextures, timePerFrame: 0.15)
    )
    legNode.run(animation, withKey: walkAnimationKey)
  }

  func stopWalkingAnimation() {
    legNode.removeAction(forKey: walkAnimationKey)
    legNode.texture = legTextures[0] // Reset to first frame
  }

  func startBlinkingAnimation() {
    guard let crabNode else {
      return
    }

    // Don't start if already blinking
    guard crabNode.action(forKey: blinkAnimationKey) == nil else { return }

    // Create blinking animation - quick fade out and in multiple times
    let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
    let blink = SKAction.sequence([fadeOut, fadeIn])

    // Repeat the blink 3 times for nice effect
    let blinkSequence = SKAction.repeat(blink, count: 3)

    // Run the blinking animation on the crab
    crabNode.run(blinkSequence, withKey: blinkAnimationKey)
  }

  func stopBlinkingAnimation() {
    guard let crabNode else { return }
    crabNode.removeAction(forKey: blinkAnimationKey)
    crabNode.alpha = 1.0 // Reset to full opacity
  }
}
