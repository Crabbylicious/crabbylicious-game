//
//  BackgroundNode.swift
//  Crabbylicious
//
//  Created by Nessa on 16/07/25.
//

import GameplayKit
import SpriteKit

class BackgroundNode: SKSpriteNode {
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: "background")
    super.init(texture: texture, color: .clear, size: size)
    position = CGPoint(x: size.width / 2, y: size.height / 2)
//    self.zPosition = 0
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
