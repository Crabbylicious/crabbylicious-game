//
//  TitleNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 17/07/25.
//

import GameplayKit
import SpriteKit

class TitleNode: SKSpriteNode {
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: "title")
    super.init(texture: texture, color: .clear, size: size)
  }
  
  func slideIn(finalPosition: CGPoint) {
    let startPosition = CGPoint(x: -self.size.width, y: finalPosition.y)
    self.position = startPosition
    
    let slideIn = SKAction.move(to: finalPosition, duration: 0.5)
    slideIn.timingMode = .easeOut
    
    run(slideIn)
  }
  
  func animation() {
    let scaleUp = SKAction.scale(to: 1.35, duration: 0.5)
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
    
    let sequence = SKAction.sequence([scaleUp, scaleDown])
    run(SKAction.repeatForever(sequence))
  }
  
  func slideInThenAnimate(finalPosition: CGPoint) {
    let startPosition = CGPoint(x: -self.size.width, y: finalPosition.y)
    self.position = startPosition
    
    let slideIn = SKAction.move(to: finalPosition, duration: 0.5)
    slideIn.timingMode = .easeOut
    
    // Run slide in, then start animation when complete
    run(slideIn) {
      self.animation()
    }
  }
  
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
