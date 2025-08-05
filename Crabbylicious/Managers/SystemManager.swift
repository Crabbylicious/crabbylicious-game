//
//  SystemManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 05/08/25.
//

import Foundation

class SystemManager {
  private var systems: [System] = []

  func addSystem(_ system: System) {
    systems.append(system)
  }

  func addSystems(_ systems: [System]) {
    self.systems.append(contentsOf: systems)
  }

  func update(deltaTime: TimeInterval, context: GameContext) {
    for system in systems {
      system.update(deltaTime: deltaTime, context: context)
    }
  }
}
