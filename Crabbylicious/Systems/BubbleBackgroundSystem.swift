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
      guard let bubbleComponent = entity.component(ofType: BubbleBackgroundComponent.self) else { continue }

      // Start the continuous animation once the entrance animation is complete
      if !hasStartedAnimation {
        // Start animation for all bubble nodes
        for bubbleNode in bubbleComponent.nodes {
          startContinuousAnimation(for: bubbleNode, sceneSize: context.scene.size)
          // Add the second node to the scene if it's not already added
          if bubbleNode.parent == nil {
            context.scene.addChild(bubbleNode)
          }
        }
        hasStartedAnimation = true
      }

      // Update the component's elapsed time
      bubbleComponent.elapsedTime += deltaTime

      // Handle seamless infinite movement for all bubble nodes
      for (index, bubbleNode) in bubbleComponent.nodes.enumerated() {
        handleSeamlessMovement(
          for: bubbleNode,
          sceneSize: context.scene.size,
          nodeIndex: index,
          allNodes: bubbleComponent.nodes
        )
      }
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

  private func handleSeamlessMovement(
    for node: SKNode,
    sceneSize: CGSize,
    nodeIndex: Int,
    allNodes: [BubbleBackgroundNode]
  ) {
    // If the bubble has moved completely above the screen, reset its position to below
    if node.position.y > sceneSize.height + 100 {
      // Find the lowest positioned node among all other nodes
      var lowestY = node.position.y
      for (index, otherNode) in allNodes.enumerated() {
        if index != nodeIndex, otherNode.position.y < lowestY {
          lowestY = otherNode.position.y
        }
      }

      // Position this node below the lowest node with proper spacing
      // Using 1920 (bubble height) minus some overlap for seamless transition
      node.position.y = lowestY - 1800 // 1920 - 120 for slight overlap
    }
  }
}
