//
//  GroundNode.swift
//  Crabbylicious
//
//  Created by Nessa on 16/07/25.
//

import GameplayKit
import SpriteKit

class GroundNode: SKSpriteNode {
  init(position: CGPoint) {
    let texture = SKTexture(imageNamed: "ground")
    super.init(texture: texture, color: .clear, size: texture.size())

    // Position the ground at the bottom of the screen
    name = "ground"
    self.position = position
    zPosition = 3
    setScale(0.35)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
