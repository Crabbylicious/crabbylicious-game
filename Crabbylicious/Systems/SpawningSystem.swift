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
    // Only spawn if game is in playing state
    guard context.gameState.state == .playing else { return }

    spawnTimer += deltaTime

    if spawnTimer >= spawnInterval {
      spawnIngredient(context: context)
      spawnTimer = 0
    }
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
