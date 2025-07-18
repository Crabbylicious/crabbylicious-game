//
//  ButtonNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit

class ButtonNode: SKSpriteNode {
  
  init(imageName: String, size: CGSize) {
    let texture = SKTexture(imageNamed: imageName)
    super.init(texture: texture, color: .clear, size: size)
  }
  
  func handleButtonPressed(button: ButtonNode) {
    let scaleDown = SKAction.scale(to: 0.975, duration: 0.3)
    button.run(scaleDown)
  }
  
  func handleButtonReleased(button: ButtonNode) {
    let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
    button.run(scaleUp)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
