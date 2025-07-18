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

  init(legNode: SKSpriteNode, legTextures: [SKTexture]) {
    self.legNode = legNode
    self.legTextures = legTextures
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
}
