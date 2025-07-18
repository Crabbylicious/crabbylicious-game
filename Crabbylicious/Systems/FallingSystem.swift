//
//  FallingSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class FallingSystem {
  func update(deltaTime seconds: TimeInterval, entityManager: EntityManager) {
    // Query entities that have FallingComponent
    let fallingEntities = entityManager.getEntitiesWith(componentType: FallingComponent.self)

    for entity in fallingEntities {
      guard let fallingComponent = entity.component(ofType: FallingComponent.self),
            let spriteComponent = entity.component(ofType: SpriteComponent.self) else { continue }

      // Apply gravity to velocity (v = v0 + g*t)
      fallingComponent.velocity += fallingComponent.gravity * CGFloat(seconds)

      // Apply terminal velocity cap
      if fallingComponent.velocity > fallingComponent.maxFallSpeed {
        fallingComponent.velocity = fallingComponent.maxFallSpeed
      }

      // Apply falling movement using current velocity (s = s0 + v*t)
      spriteComponent.node.position.y -= fallingComponent.velocity * CGFloat(seconds)

      // Apply rotation animation
      spriteComponent.node.zRotation += fallingComponent.rotationSpeed * CGFloat(seconds)
    }
  }
}
