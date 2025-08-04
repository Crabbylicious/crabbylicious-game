//
//  CurrentRecipeComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import Foundation
import GameplayKit

class CurrentRecipeComponent: GKComponent {
  var currentRecipe: Recipe
  var collectedIngredients: [Ingredient: Int] = [:]
  var isRecipeCompleted: Bool = false

  init(recipe: Recipe) {
    currentRecipe = recipe
    for (ingredient, _) in currentRecipe.ingredients {
      collectedIngredients[ingredient] = 0
    }
    super.init()
  }

  func updateRecipe(_ newRecipe: Recipe) {
    currentRecipe = newRecipe
    for (ingredient, _) in currentRecipe.ingredients {
      collectedIngredients[ingredient] = 0
    }
    isRecipeCompleted = false
  }

  func caughtIngredient(_ ingredient: Ingredient) {
    collectedIngredients[ingredient, default: 0] += 1
    if checkRecipeCompletion() {
      isRecipeCompleted = true
    }
  }

  private func checkRecipeCompletion() -> Bool {
    currentRecipe.ingredients.allSatisfy { ingredient, count in
      collectedIngredients[ingredient] == count
    }
  }

  // MARK: - Smart Ingredient Selection

  /// Select ingredient using weighted random algorithm
  /// - 50% weight: Needed ingredients (not yet fulfilled)
  /// - 10% weight: Needed ingredients (already fulfilled)
  /// - 15% weight: Non-recipe ingredients
  /// - 25% weight: Trap ingredients
  func selectSmartIngredient() -> Ingredient {
    var weightedIngredients: [(ingredient: Ingredient, weight: Float)] = []

    // Get current recipe requirements
    let recipe = currentRecipe

    // Categorize ingredients and assign weights
    for ingredient in GameData.allIngredients {
      let weight: Float

      if ingredient.isAbsurd {
        // Trap ingredients: 25% weight
        weight = 25.0
      } else if let requiredAmount = recipe.ingredients[ingredient] {
        // This ingredient is in current recipe
        let collectedAmount = collectedIngredients[ingredient] ?? 0

        if collectedAmount < requiredAmount {
          // Still needed: 50% weight
          weight = 50.0
        } else {
          // Already fulfilled: 10% weight
          weight = 10.0
        }
      } else {
        // Not in recipe: 15% weight
        weight = 15.0
      }

      weightedIngredients.append((ingredient: ingredient, weight: weight))
    }

    // Select based on weights
    return selectWeightedRandom(from: weightedIngredients)
  }

  /// Helper function to select random item based on weights
  private func selectWeightedRandom(from weightedItems: [(ingredient: Ingredient, weight: Float)]) -> Ingredient {
    let totalWeight = weightedItems.reduce(0) { $0 + $1.weight }
    let randomValue = Float.random(in: 0 ..< totalWeight)

    var currentWeight: Float = 0
    for item in weightedItems {
      currentWeight += item.weight
      if randomValue < currentWeight {
        return item.ingredient
      }
    }

    // Fallback (should never reach here)
    return weightedItems.first?.ingredient ?? GameData.allIngredients.first!
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
