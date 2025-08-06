//
//  ButtonNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit

class ButtonNode: SKSpriteNode {
  init(imageName: String, scale: CGFloat = 0.4, alpha: CGFloat = 1.0) {
    let texture = SKTexture(imageNamed: imageName)
    super.init(texture: texture, color: .clear, size: texture.size())

    self.alpha = alpha
    name = imageName

    setScale(scale)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
