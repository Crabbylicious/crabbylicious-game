//
//  IngredientDisplayNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SpriteKit

class IngredientDisplayNode: SKNode {
  private let ingredient: Ingredient
  private var count: Int

  private var ingredientSprite: SKSpriteNode!
  private var countLabel: SKLabelNode!

  init(ingredient: Ingredient, count: Int) {
    self.ingredient = ingredient
    self.count = count
    super.init()
    setupDisplay()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupDisplay() {
    // Create ingredient sprite
    ingredientSprite = SKSpriteNode(imageNamed: ingredient.imageName)
    ingredientSprite.size = CGSize(width: 40, height: 40)
    ingredientSprite.position = CGPoint(x: 0, y: 8)
    addChild(ingredientSprite)

    // Create count label
    countLabel = SKLabelNode(text: "\(count)")
    countLabel.fontName = "Press Start 2P"
    countLabel.fontSize = 12
    countLabel.fontColor = .black
    countLabel.position = CGPoint(x: 0, y: -40)
    countLabel.horizontalAlignmentMode = .center
    addChild(countLabel)
  }

  func updateCount(_ newCount: Int) {
    count = newCount
    countLabel.text = "\(count)"

    // Add visual feedback when count changes
    if count == 0 {
      let fadeAction = SKAction.fadeAlpha(to: 0.3, duration: 0.3)
      run(fadeAction)
    } else {
      // Bounce effect when count updates
      let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
      let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
      let bounce = SKAction.sequence([scaleUp, scaleDown])
      countLabel.run(bounce)
    }
  }
}

extension GameState {
  // Add this property to track collected ingredients
  //private static var collectedIngredients: [Ingredient: Int] = [:]

  func getRemainingIngredients() -> [Ingredient: Int] {
    var remaining: [Ingredient: Int] = [:]

    for (ingredient, required) in currentRecipe.ingredients {
      let collected = self.collectedIngredients[ingredient] ?? 0
      let stillNeeded = max(0, required - collected)
      remaining[ingredient] = stillNeeded
    }

    return remaining
  }

  func collectIngredient(_ ingredient: Ingredient) -> Bool {
    // Check if this ingredient is needed for current recipe
    guard let required = currentRecipe.ingredients[ingredient] else {
      return false // Not needed for current recipe
    }

    let currentCollected = collectedIngredients[ingredient] ?? 0

    // Check if we still need this ingredient
    if currentCollected < required {
      collectedIngredients[ingredient] = currentCollected + 1
      return true // Successfully collected
    }

    return false // Already have enough of this ingredient
  }

  func resetCollectedIngredients() {
    self.collectedIngredients.removeAll()
  }

//  func isRecipeComplete() -> Bool {
//    for (ingredient, required) in currentRecipe.ingredients {
//      let collected = GameState.collectedIngredients[ingredient] ?? 0
//      if collected < required {
//        return false
//      }
//    }
//    return true
//  }

//  func getTotalIngredientsRemaining() -> Int {
//    getRemainingIngredients().values.reduce(0, +)
//  }
  // Add the moveToNextRecipe method here as well
  
  func moveToNextRecipe() {
    print("🔍 DEBUG: === MOVING TO NEXT RECIPE ===")
    print("🔍 DEBUG: Current recipe before move: \(currentRecipe.name)")
    print("🔍 DEBUG: Current collected ingredients before reset: \(collectedIngredients)")
    
    // CRITICAL: Reset collected ingredients for the new recipe
    resetCollectedIngredients()
    print("🔍 DEBUG: ✅ Collected ingredients cleared: \(collectedIngredients)")
    
    // Move to next recipe (adjust this based on your actual implementation)
    currentRecipeIndex += 1
    if currentRecipeIndex >= GameData.recipes.count {
      currentRecipeIndex = 0 // Loop back or handle end game
      print("🔍 DEBUG: Looped back to first recipe")
    }
    
    print("🔍 DEBUG: New recipe index: \(currentRecipeIndex)")
    print("🔍 DEBUG: New current recipe: \(currentRecipe.name)")
    print("🔍 DEBUG: New recipe ingredients: \(currentRecipe.ingredients)")
    print("🔍 DEBUG: === RECIPE MOVE COMPLETED ===")
  }

  func getTotalIngredientsRemaining() -> Int {
    getRemainingIngredients().values.reduce(0, +)
  }
  
  // Debug method to check current state
  func debugCurrentState() {
    print("🔍 DEBUG: === GAMESTATE DEBUG ===")
    print("🔍 DEBUG: Current recipe index: \(currentRecipeIndex)")
    print("🔍 DEBUG: Current recipe: \(currentRecipe.name)")
    print("🔍 DEBUG: Recipe ingredients: \(currentRecipe.ingredients)")
    print("🔍 DEBUG: Collected ingredients: \(collectedIngredients)")
    print("🔍 DEBUG: Recipe complete: \(isRecipeComplete())")
    print("🔍 DEBUG: =====================")
  }
}
