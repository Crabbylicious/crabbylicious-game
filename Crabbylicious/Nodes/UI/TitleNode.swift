//
//  TitleNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 17/07/25.
//

import GameplayKit
import SpriteKit

class TitleNode: SKSpriteNode {
  init(position: CGPoint) {
    let texture = SKTexture(imageNamed: "title")
    super.init(texture: texture, color: .clear, size: texture.size())
    self.position = position
    name = "title"
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
