//
//  ButtonPressAnimation.swift
//  Crabbylicious
//
//  Created by Nessa on 24/07/25.
//

import SpriteKit

func animateButtonPress(_ button: SKNode, completion: @escaping () -> Void) {
  // Play button sound effect
  SoundManager.sound.allButtonSound()

  let originalX = button.xScale
  let originalY = button.yScale

  // Enhanced button press animation - more dramatic and slower
  let scaleDown = SKAction.scaleX(to: originalX * 0.85, y: originalY * 0.85, duration: 0.15)
  let scaleUp = SKAction.scaleX(to: originalX * 1.1, y: originalY * 1.1, duration: 0.2)
  let scaleBack = SKAction.scaleX(to: originalX, y: originalY, duration: 0.15)

  // Add some easing for smoother animation
  scaleDown.timingMode = .easeIn
  scaleUp.timingMode = .easeOut
  scaleBack.timingMode = .easeInEaseOut

  let sequence = SKAction.sequence([
    scaleDown,
    scaleUp,
    scaleBack,
    SKAction.run(completion)
  ])

  button.run(sequence)
}

// Enhanced button press animation for special buttons (like play button)
func animateSpecialButtonPress(_ button: SKNode, completion: @escaping () -> Void) {
  // Play start button sound for special buttons
  SoundManager.sound.startButtonSound()

  let originalX = button.xScale
  let originalY = button.yScale

  // More dramatic animation for special buttons
  let scaleDown = SKAction.scaleX(to: originalX * 0.8, y: originalY * 0.8, duration: 0.2)
  let bounce1 = SKAction.scaleX(to: originalX * 1.15, y: originalY * 1.15, duration: 0.15)
  let bounce2 = SKAction.scaleX(to: originalX * 0.95, y: originalY * 0.95, duration: 0.1)
  let scaleBack = SKAction.scaleX(to: originalX, y: originalY, duration: 0.1)

  // Add easing
  scaleDown.timingMode = .easeIn
  bounce1.timingMode = .easeOut
  bounce2.timingMode = .easeInEaseOut
  scaleBack.timingMode = .easeOut

  let sequence = SKAction.sequence([
    scaleDown,
    bounce1,
    bounce2,
    scaleBack,
    SKAction.run(completion)
  ])

  button.run(sequence)
}
