//
//  CountdownNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 22/07/25.
//

import GameplayKit
import SpriteKit

class CountdownNode: SKSpriteNode {
  // Animation timing constants
  private let scaleInDuration: TimeInterval = 0.3
  private let fadeOutDuration: TimeInterval = 0.3
  private let displayScale: CGFloat = 0.5

  init(number: Int, position: CGPoint = CGPoint.zero) {
    let imageName = "countdown\(number)" // countdown3, countdown2, countdown1
    let texture = SKTexture(imageNamed: imageName)

    super.init(texture: texture, color: .clear, size: texture.size())

    self.position = position
    zPosition = 100 // High z-position to appear above everything
    setScale(0.1) // Start small for scale-in animation
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Animation Methods

  /// Animates the countdown number with scale in, pause, fade out
  /// - Parameters:
  ///   - pauseDuration: How long to display the number
  ///   - completion: Called when animation completes
  func animateCountdown(pauseDuration: TimeInterval, completion: @escaping () -> Void) {
    // Scale in with bounce effect
    let scaleIn = SKAction.scale(to: displayScale, duration: scaleInDuration)
    scaleIn.timingMode = .easeOut

    // Pause to display the number
    let pause = SKAction.wait(forDuration: pauseDuration)

    // Fade out while maintaining size
    let fadeOut = SKAction.fadeOut(withDuration: fadeOutDuration)

    // Remove from parent
    let remove = SKAction.removeFromParent()

    let sequence = SKAction.sequence([scaleIn, pause, fadeOut, remove])

    run(sequence, completion: completion)
  }
}
