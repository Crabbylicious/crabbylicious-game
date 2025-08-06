//
//  ButtonNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit

class ButtonNode: SKSpriteNode {
  private let initialScale: CGFloat

  init(imageName: String, scale: CGFloat = 0.4, alpha: CGFloat = 1.0) {
    let texture = SKTexture(imageNamed: imageName)
    initialScale = scale
    super.init(texture: texture, color: .clear, size: texture.size())

    self.alpha = alpha
    name = "button_\(imageName)"

    setScale(scale)
  }

  func actionButtonPressed(button: ButtonNode) {
    let scaleDown = SKAction.scale(to: initialScale * 0.98, duration: 0.1)
    button.run(scaleDown)
  }

  func actionButtonReleased(button: ButtonNode) {
    let scaleUp = SKAction.scale(to: initialScale * 1.02, duration: 0.1)
    let scaleBack = SKAction.scale(to: initialScale, duration: 0.1)
    let sequence = SKAction.sequence([scaleUp, scaleBack])
    button.run(sequence)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
