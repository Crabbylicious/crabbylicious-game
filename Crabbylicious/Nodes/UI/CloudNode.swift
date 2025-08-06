//
//  CloudNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 18/07/25.
//

import GameplayKit
import SpriteKit

class CloudNode: SKSpriteNode {
  init(position: CGPoint, name: String) {
    let texture = SKTexture(imageNamed: "cloud")
    super.init(texture: texture, color: .clear, size: CGSize(width: 193, height: 193))
    self.name = name
    self.position = position
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
