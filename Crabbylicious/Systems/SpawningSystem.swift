//
//  SpawningSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import Foundation

class SpawningSystem: System {
  private var spawnTimer: TimeInterval = 0
  private let baseSpawnInterval: TimeInterval = 2.0
  private let minSpawnInterval: TimeInterval = 0.25 // Minimum spawn interval to prevent it becoming too fast
  private var lastLoggedInterval: TimeInterval = 0.0 // Track last logged interval for debug

  func update(deltaTime: TimeInterval, context: GameContext) {
    // Only spawn if game is in playing state
    guard context.gameState.state == .playing else { return }

    spawnTimer += deltaTime
    let currentSpawnInterval = calculateSpawnInterval(context: context)

    if spawnTimer >= currentSpawnInterval {
      spawnIngredient(context: context)
      spawnTimer = 0
    }
  }

  private func calculateSpawnInterval(context: GameContext) -> TimeInterval {
    let ingredientsCaught = context.gameState.totalIngredientsCaught
    let currentLevel = context.gameState.currentLevel

    // Reduce spawn interval for every ingredients caught
    let ingredientReduction = Double(ingredientsCaught) * 0.15

    // Additional reduction based on level progression
    let levelReduction = Double(currentLevel - 1) * 0.15

    // Calculate the final spawn interval
    let dynamicInterval = baseSpawnInterval - ingredientReduction - levelReduction

    // Ensure it doesn't go below minimum interval
    let finalInterval = max(minSpawnInterval, dynamicInterval)

    // Debug print to track difficulty progression (only when interval changes)
    #if DEBUG
      if abs(finalInterval - lastLoggedInterval) > 0.01 {
        print(
          "🦀 Spawn Interval Updated: \(String(format: "%.2f", finalInterval))s | Ingredients: \(ingredientsCaught) | Level: \(currentLevel)"
        )
        lastLoggedInterval = finalInterval
      }
    #endif

    return finalInterval
  }

  private func spawnIngredient(context: GameContext) {
    // Use GameData configuration for spawn positioning
    let margin = 50.0
    let randomX = CGFloat.random(in: context.scene.frame.minX + margin ... context.scene.frame.maxX - margin)
    let spawnY = context.scene.frame.maxY + margin

    // Get ingredient using smart selection if recipe component exists
    let ingredientData: Ingredient = getSmartIngredient(context: context)

    let ingredient = EntityFactory.createIngredient(
      ingredient: ingredientData,
      position: CGPoint(x: randomX, y: spawnY)
    )

    context.entityManager.addEntity(ingredient)

    // Add to scene
    if let spriteComponent = ingredient.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(context.scene)
    }
  }

  private func getSmartIngredient(context: GameContext) -> Ingredient {
    // Try to get smart ingredient from recipe component
    if let recipeEntity = context.entityManager.getEntitiesWith(componentType: CurrentRecipeComponent.self).first,
       let recipeComponent = recipeEntity.component(ofType: CurrentRecipeComponent.self)
    {
      return recipeComponent.selectSmartIngredient()
    }

    // Fallback to random ingredient
    return GameData.allIngredients.randomElement() ?? GameData.allIngredients[0]
  }
}
