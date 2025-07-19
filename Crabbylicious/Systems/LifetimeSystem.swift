//
//  LifetimeSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

// lifetime of the Entity, to be removed after falling
class LifetimeSystem {
  private weak var scene: SeamlessScene?

  init(scene: SeamlessScene) {
    self.scene = scene
  }

  func update(deltaTime seconds: TimeInterval, entityManager: EntityManager) {
    // Query entities that have LifetimeComponent
    let lifetimeEntities = entityManager.getEntitiesWith(componentType: LifetimeComponent.self)
    var entitiesToRemove: [GKEntity] = []

    for entity in lifetimeEntities {
      guard let lifetimeComponent = entity.component(ofType: LifetimeComponent.self) else { continue }

      lifetimeComponent.timeRemaining -= seconds

      if lifetimeComponent.timeRemaining <= 0 {
        entitiesToRemove.append(entity)
      }
    }

    // Remove expired entities
    for entity in entitiesToRemove {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        spriteComponent.node.removeFromParent()
      }
      scene?.removeEntity(entity)
    }
  }
}
