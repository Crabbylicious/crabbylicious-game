//
//  BubbleBackgroundSystem.swift
//  Crabbylicious
//
//  Created by AI Nessa on 21/07/25.
//

import Foundation
import SpriteKit

class BubbleBackgroundSystem: System {
  private var hasStartedAnimation = false

  func update(deltaTime: TimeInterval, context: GameContext) {
    // Only process if game is playing or paused (bubbles should animate even when paused for visual continuity)
    guard context.gameState.state == .playing || context.gameState.state == .paused else { return }

    let bubbleEntities = context.entityManager.getEntitiesWith(componentType: BubbleBackgroundComponent.self)

    for entity in bubbleEntities {
      guard let bubbleComponent = entity.component(ofType: BubbleBackgroundComponent.self),
            let spriteComponent = entity.component(ofType: SpriteComponent.self) else { continue }

      // Start the continuous animation once the entrance animation is complete
      if !hasStartedAnimation {
        startContinuousAnimation(for: spriteComponent.node, sceneSize: context.scene.size)
        hasStartedAnimation = true
      }

      // Update the component's elapsed time
      bubbleComponent.elapsedTime += deltaTime

      // Handle seamless infinite movement (repositioning when bubble goes off-screen)
      handleSeamlessMovement(for: spriteComponent.node, sceneSize: context.scene.size)
    }
  }

  private func startContinuousAnimation(for node: SKNode, sceneSize: CGSize) {
    // Continuous left-right swaying animation
    let swayLeft = SKAction.moveBy(x: -20, y: 0, duration: 3.0)
    let swayRight = SKAction.moveBy(x: 40, y: 0, duration: 6.0)
    let swayBackLeft = SKAction.moveBy(x: -20, y: 0, duration: 3.0)

    swayLeft.timingMode = .easeInEaseOut
    swayRight.timingMode = .easeInEaseOut
    swayBackLeft.timingMode = .easeInEaseOut

    let swaySequence = SKAction.sequence([swayLeft, swayRight, swayBackLeft])
    let swayForever = SKAction.repeatForever(swaySequence)

    // Continuous upward movement
    let moveUp = SKAction.moveBy(x: 0, y: sceneSize.height + 200, duration: 60.0) // Slow upward movement
    let moveUpForever = SKAction.repeatForever(moveUp)

    // Run both animations simultaneously
    node.run(swayForever, withKey: "sway")
    node.run(moveUpForever, withKey: "moveUp")
  }

  private func handleSeamlessMovement(for node: SKNode, sceneSize: CGSize) {
    // If the bubble has moved completely above the screen, reset its position to below
    if node.position.y > sceneSize.height + 100 {
      node.position.y = -sceneSize.height - 100
    }
  }
}
