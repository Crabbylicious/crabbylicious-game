//
//  SpawningSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import Foundation

class SpawningSystem: System {
  private var spawnTimer: TimeInterval = 0
  private let spawnInterval: TimeInterval = 2.0

  func update(deltaTime: TimeInterval, context: GameContext) {
    spawnTimer += deltaTime

    if spawnTimer >= spawnInterval {
      spawnFruit(context: context)
      spawnTimer = 0
    }
  }

  private func spawnFruit(context: GameContext) {
    // Use GameData configuration for spawn positioning
    let margin = 50.0
    let randomX = CGFloat.random(in: context.scene.frame.minX + margin ... context.scene.frame.maxX - margin)
    let spawnY = context.scene.frame.maxY + margin

    // Get a random fruit from GameData
    let ingredientData = GameData.allIngredients.randomElement() ?? GameData.allIngredients[0]

    let ingredient = EntityFactory.createIngredient(
      ingredient: ingredientData,
      position: CGPoint(x: randomX, y: spawnY)
    )

    context.entityManager.addEntity(ingredient)
  }
}
