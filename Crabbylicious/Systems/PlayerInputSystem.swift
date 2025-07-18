//
//  PlayerInputSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class PlayerInputSystem {
  private var currentTouchDelta: CGFloat = 0
  private var isMoving = false

  func update(deltaTime _: TimeInterval, entityManager: EntityManager) {
    // Query entities that have PlayerControlComponent
    let playerEntities = entityManager.getEntitiesWith(componentType: PlayerControlComponent.self)

    for entity in playerEntities {
      guard let playerControl = entity.component(ofType: PlayerControlComponent.self),
            playerControl.isControllable,
            let spriteComponent = entity.component(ofType: SpriteComponent.self),
            let animationComponent = entity.component(ofType: AnimationComponent.self) else { continue }

      if currentTouchDelta != 0 {
        // Move the crab
        var newX = spriteComponent.node.position.x + currentTouchDelta

        // Apply boundaries
        let margin = spriteComponent.node.size.width / 1.1
        newX = max(
          playerControl.gameArea.minX + margin,
          min(
            playerControl.gameArea.maxX - margin,
            newX
          )
        )
        spriteComponent.node.position.x = newX

        // Start animation if not already moving
        if !isMoving {
          animationComponent.startWalkingAnimation()
          isMoving = true
        }
      } else if isMoving {
        // Stop animation
        animationComponent.stopWalkingAnimation()
        isMoving = false
      }
    }

    // Reset touch delta after processing
    currentTouchDelta = 0
  }

  func handleTouchMoved(delta: CGFloat) {
    currentTouchDelta = delta
  }

  func handleTouchEnded() {
    currentTouchDelta = 0
  }
}
