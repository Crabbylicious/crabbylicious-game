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

  private init() {
    currentRecipe = GameData.recipes[0] // Start with Gado-Gado
  }

  func getCurrentFallSpeed() -> CGFloat {
    150.0 * CGFloat(difficultyMultiplier)
  }
}
