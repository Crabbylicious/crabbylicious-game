//
//  LifecycleSystem.swift
//  FruitCatcher
//
//  Created by Java Kanaya Prada on 27/07/25.
//

import Foundation

class LifecycleSystem: System {
  func update(deltaTime _: TimeInterval, context: GameContext) {
    let entities = context.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
            let lifecycle = entity.component(ofType: LifecycleComponent.self) else { continue }

      // Remove entities that fall below screen
      if spriteComponent.position.y < context.gameArea.minY - 100 {
        lifecycle.markForRemoval()
      }
    }
  }
}
