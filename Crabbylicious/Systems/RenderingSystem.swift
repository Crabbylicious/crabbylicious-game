//
//  RenderingSystem.swift
//  FruitCatcher
//
//  Created by Java Kanaya Prada on 27/07/25.
//

import GameplayKit
import SpriteKit

class RenderingSystem: System {
  private var scene: SKScene

  init(scene: SKScene) {
    self.scene = scene
  }

  func update(deltaTime _: TimeInterval, context: GameContext) {
    handleNewEntities(context: context, scene: scene)
    handleRemovals(context: context, scene: scene)
  }

  private func handleNewEntities(context: GameContext, scene: SKScene) {
    let newEntities = context.entityManager.getEntitiesWith(componentType: LifecycleComponent.self)

    for entity in newEntities {
      guard let lifecycle = entity.component(ofType: LifecycleComponent.self),
            lifecycle.state == .created,
            let sprite = entity.component(ofType: SpriteComponent.self) else { continue }

      if sprite.node.parent == nil {
        sprite.addToScene(scene)
        lifecycle.state = .active
      }
    }
  }

  private func handleRemovals(context: GameContext, scene _: SKScene) {
    let entities = context.entityManager.getEntitiesWith(componentType: LifecycleComponent.self)
    var entitiesToRemove: [GKEntity] = []

    for entity in entities {
      guard let lifecycle = entity.component(ofType: LifecycleComponent.self),
            lifecycle.state == .markedForRemoval else { continue }

      // Remove from scene
      if let sprite = entity.component(ofType: SpriteComponent.self) {
        sprite.removeFromParent()
      }

      entitiesToRemove.append(entity)
    }

    // Remove from entity manager
    entitiesToRemove.forEach { context.entityManager.removeEntity($0) }
  }
}
