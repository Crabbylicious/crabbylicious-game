//
//  GroundNode.swift
//  Crabbylicious
//
//  Created by Nessa on 16/07/25.
//

import GameplayKit
import SpriteKit

class GroundNode: SKSpriteNode {
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: "ground")
    super.init(texture: texture, color: .clear, size: size)

    // Position the ground at the bottom of the screen
    position = CGPoint(x: size.width / 2, y: self.size.height / 2)
    zPosition = 2
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
