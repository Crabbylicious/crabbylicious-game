//
//  CloudNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 18/07/25.
//

import GameplayKit
import SpriteKit

class CloudNode: SKSpriteNode {
  static let cloudSize = CGSize(width: 193, height: 193)

  init(position: CGPoint = CGPoint(x: 0, y: 0)) {
    let texture = SKTexture(imageNamed: "cloud")
    super.init(texture: texture, color: .clear, size: CloudNode.cloudSize)

    self.position = position
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
