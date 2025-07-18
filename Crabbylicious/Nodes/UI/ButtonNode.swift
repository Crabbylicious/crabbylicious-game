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
    let buttonSize = CGSize(width: size.width, height: size.height / 1.25)
    super.init(texture: texture, color: .clear, size: buttonSize)
  }
  
  func handleButtonPressed(button: ButtonNode) {
    let scaleDown = SKAction.scale(to: 0.99, duration: 0.3)
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
