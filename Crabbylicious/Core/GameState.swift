//
//  GameState.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation

// MARK: - Game State Singleton

class GameState {
  static let shared = GameState()

  var currentRecipe: Recipe
  var difficultyMultiplier: Float = 1.0
  var ingredientSpawnTimer: TimeInterval = 0
  let ingredientSpawnInterval: TimeInterval = 2.0

  var collectedIngredients: [Ingredient: Int] = [:]

  var currentRecipeIndex: Int = 0
  var score: Int = 0
  var lives: Int = 3

  private init() {
    currentRecipe = GameData.recipes[0] // Start with Gado-Gado
  }

  func getCurrentFallSpeed() -> CGFloat {
    150.0 * CGFloat(difficultyMultiplier)
  }

  func addCollectedIngredient(_ ingredient: Ingredient) {
    let current = collectedIngredients[ingredient] ?? 0
    collectedIngredients[ingredient] = current + 1
    
    print("Added \(ingredient.name). Now have: \(collectedIngredients[ingredient]!)")
    print("Recipe needs: \(currentRecipe.ingredients)")
    print("Currently have: \(collectedIngredients)")
  }
  
  func isRecipeComplete() -> Bool {
    for (ingredient, needed) in currentRecipe.ingredients {
      let have = collectedIngredients[ingredient] ?? 0
      if have < needed {
        return false
      }
    }
    return true
  }

  /// Move to next recipe
  func moveToNextRecipe() {
    currentRecipeIndex += 1

    // Check if we've completed all recipes
    if currentRecipeIndex >= GameData.recipes.count {
      currentRecipeIndex = 0 // Loop back to beginning
      difficultyMultiplier += 0.5 // Increase difficulty
      print("🎉 All recipes completed! Increasing difficulty to \(difficultyMultiplier)")
    }

    // Set new current recipe and reset ingredients
    currentRecipe = GameData.recipes[currentRecipeIndex]
    resetCollectedIngredients()
    
    print("🍽️ New recipe: \(currentRecipe.name)")
  }

  // MARK: - Smart Ingredient Selection

  /// Select ingredient using weighted random algorithm
  /// - 70% weight: Needed ingredients (not yet fulfilled)
  /// - 10% weight: Needed ingredients (already fulfilled)
  /// - 15% weight: Non-recipe ingredients
  /// - 5% weight: Trap ingredients
  func selectSmartIngredient() -> Ingredient {
    var weightedIngredients: [(ingredient: Ingredient, weight: Float)] = []

    // Get current recipe requirements
    let recipe = currentRecipe

    // Categorize ingredients and assign weights
    for ingredient in GameData.allIngredients {
      let weight: Float

      if ingredient.isAbsurd {
        // Trap ingredients: 5% weight
        weight = 5.0
      } else if let requiredAmount = recipe.ingredients[ingredient] {
        // This ingredient is in current recipe
        let collectedAmount = collectedIngredients[ingredient] ?? 0

        if collectedAmount < requiredAmount {
          // Still needed: 70% weight
          weight = 70.0
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
}
