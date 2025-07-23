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
  
  private var currentRecipeIndex: Int = 0
  var score: Int = 0
  var lives: Int = 3
  
  private init() {
    currentRecipe = GameData.recipes[0] // Start with Gado-Gado
  }
  
  func getCurrentFallSpeed() -> CGFloat {
    150.0 * CGFloat(difficultyMultiplier)
  }
  

  func addCollectedIngredient(_ ingredient: Ingredient) {
      let success = collectIngredient(ingredient)
      
      if success {
        print("🥬 Collected \(ingredient.name)")
      } else {
        print("⚠️ Ingredient \(ingredient.name) not needed or already have enough")
      }
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
}
