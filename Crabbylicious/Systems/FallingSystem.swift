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

      // Apply falling movement
      spriteComponent.node.position.y -= fallingComponent.fallSpeed * CGFloat(seconds)

      // Apply rotation animation
      spriteComponent.node.zRotation += fallingComponent.rotationSpeed * CGFloat(seconds)
    }
  }
}
