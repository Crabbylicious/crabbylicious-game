//
//  ButtonPressAnimation.swift
//  Crabbylicious
//
//  Created by Nessa on 24/07/25.
//

import SpriteKit

func animateButtonPress(_ button: SKNode, completion: @escaping () -> Void) {
  let originalX = button.xScale
  let originalY = button.yScale

  let scaleDown = SKAction.scaleX(to: originalX * 0.95, y: originalY * 0.95, duration: 0.1)
  let scaleUp = SKAction.scaleX(to: originalX * 1.05, y: originalY * 1.05, duration: 0.1)
  let scaleBack = SKAction.scaleX(to: originalX, y: originalY, duration: 0.1)

  let sequence = SKAction.sequence([
    scaleDown,
    scaleUp,
    scaleBack,
    SKAction.run(completion)
  ])

  button.run(sequence)
}
