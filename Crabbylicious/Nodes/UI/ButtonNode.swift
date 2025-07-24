//
//  ButtonNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit

class ButtonNode: SKSpriteNode {
  var onButtonTapped: (() -> Void)?

  init(imageName: String, scale: CGFloat = 0.4, alpha: CGFloat = 1.0) {
    let texture = SKTexture(imageNamed: imageName)
    // Use the actual texture size, then scale if needed
    super.init(texture: texture, color: .clear, size: texture.size())

    setScale(scale)
    self.alpha = alpha
  }

  func handleButtonPressed(button: ButtonNode) {
    let scaleDown = SKAction.scale(to: 0.38, duration: 0.3)
    button.run(scaleDown)
  }

  func handleButtonReleased(button: ButtonNode) {
    let scaleUp = SKAction.scale(to: 0.42, duration: 0.3)
    button.run(scaleUp)

    onButtonTapped?()
  }

  func fadeIn() {
    let fadeIn = SKAction.fadeIn(withDuration: 0.5)
    run(fadeIn)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
