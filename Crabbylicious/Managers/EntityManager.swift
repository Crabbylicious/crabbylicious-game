//
//  EntityManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

// MARK: - Entity Manager

class EntityManager {
  private var entities: Set<GKEntity> = []

  func addEntity(_ entity: GKEntity) {
    entities.insert(entity)
  }

  func removeEntity(_ entity: GKEntity) {
    entities.remove(entity)
  }

  func getEntitiesWith(componentType: (some GKComponent).Type) -> [GKEntity] {
    entities.filter { $0.component(ofType: componentType) != nil }
  }

  func getAllEntities() -> [GKEntity] {
    Array(entities)
  }
}
