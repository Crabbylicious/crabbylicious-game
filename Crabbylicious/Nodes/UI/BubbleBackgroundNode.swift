//
//  BubbleBackgroundNode.swift
//  Crabbylicious
//
//  Created by Nessa on 21/07/25.
//

import GameplayKit
import SpriteKit

class BubbleBackgroundNode: SKSpriteNode {
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: "BubbleBackground")
    let dimention = CGSize(width: 1080, height: 1920)
    super.init(texture: texture, color: .clear, size: dimention)
    position = CGPoint(x: size.width / 2, y: size.height / 2)
    zPosition = 1
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
