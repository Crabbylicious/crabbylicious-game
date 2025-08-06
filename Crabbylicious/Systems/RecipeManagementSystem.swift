//
//  RecipeManagementSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import GameplayKit
import SpriteKit

class RecipeManagementSystem: System {
  private var recipeCardEntity: GKEntity?
  private var currentRecipeIndex = 0

  func update(deltaTime _: TimeInterval, context: GameContext) {
    // Find recipe card entity if not cached
    if recipeCardEntity == nil {
      recipeCardEntity = context.entityManager.getEntitiesWith(componentType: CurrentRecipeComponent.self).first
    }

    guard let recipeEntity = recipeCardEntity,
          let recipeComponent = recipeEntity.component(ofType: CurrentRecipeComponent.self),
          let spriteComponent = recipeEntity.component(ofType: SpriteComponent.self),
          let recipeCardNode = spriteComponent.node as? RecipeCardNode else { return }

    // Check if recipe is completed
    if recipeComponent.isRecipeCompleted {
      handleRecipeCompletion(context: context, recipeComponent: recipeComponent, recipeCardNode: recipeCardNode)
    }
  }

  private func handleRecipeCompletion(
    context: GameContext,
    recipeComponent: CurrentRecipeComponent,
    recipeCardNode: RecipeCardNode
  ) {
    // Mark recipe as completed in game state
    context.gameState.completeRecipe()

    // Add completion bonus score
    if let scoreEntity = context.entityManager.getEntitiesWith(componentType: ScoreComponent.self).first,
       let scoreComponent = scoreEntity.component(ofType: ScoreComponent.self)
    {
      scoreComponent.addScore(100) // Bonus for completing recipe
    }

    // Prepare for next recipe
    currentRecipeIndex = (currentRecipeIndex + 1) % GameData.recipes.count
    let nextRecipe = GameData.recipes[currentRecipeIndex]

    // Reset recipe component for next recipe
    recipeComponent.updateRecipe(nextRecipe)
    recipeCardNode.updateRecipe(nextRecipe)

    // Play completion sound
    SoundManager.sound.playCorrectSound()
    HapticManager.haptic.playSuccessHaptic()
  }

  func handleIngredientCatch(_ ingredient: Ingredient, context: GameContext) {
    guard let recipeEntity = recipeCardEntity ?? context.entityManager
      .getEntitiesWith(componentType: CurrentRecipeComponent.self).first,
      let recipeComponent = recipeEntity.component(ofType: CurrentRecipeComponent.self),
      let spriteComponent = recipeEntity.component(ofType: SpriteComponent.self),
      let recipeCardNode = spriteComponent.node as? RecipeCardNode else { return }

    let isNeededIngredient = recipeComponent.currentRecipe.ingredients[ingredient] != nil
    let collectedCount = recipeComponent.collectedIngredients[ingredient] ?? 0
    let requiredCount = recipeComponent.currentRecipe.ingredients[ingredient] ?? 0

    if isNeededIngredient, collectedCount < requiredCount {
      // This ingredient is needed and we haven't collected enough yet
      recipeComponent.caughtIngredient(ingredient)

      // Update the visual display
      let remainingCount = max(0, requiredCount - (collectedCount + 1))
      recipeCardNode.updateIngredientCount(ingredient, remainingCount)

      // Add points for correct ingredient
      if let scoreEntity = context.entityManager.getEntitiesWith(componentType: ScoreComponent.self).first,
         let scoreComponent = scoreEntity.component(ofType: ScoreComponent.self)
      {
        scoreComponent.addScore(10)
      }

      SoundManager.sound.playCorrectSound()
      HapticManager.haptic.playSuccessHaptic()

    } else {
      // Wrong ingredient or already have enough
      if let lifeEntity = context.entityManager.getEntitiesWith(componentType: LifeComponent.self).first,
         let lifeComponent = lifeEntity.component(ofType: LifeComponent.self)
      {
        lifeComponent.loseLife()

        if lifeComponent.isGameOver() {
          context.gameState.gameOver()
        }
      }

      SoundManager.sound.playWrongSound()
      HapticManager.haptic.playFailureHaptic()
    }
  }
}
