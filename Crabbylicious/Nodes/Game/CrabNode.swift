//
//  CrabNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class CrabNode: SKSpriteNode {
  init(size _: CGSize) {
    let texture = SKTexture(imageNamed: "crabAndBowl2")
    super.init(texture: texture, color: .clear, size: texture.size())
    setScale(0.15)
    zPosition = 2
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
