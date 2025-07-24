//
//  RecipeCardNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 21/07/25.
//

import GameplayKit
import SpriteKit

class RecipeCardNode: SKSpriteNode {
  private let cardBackground: SKSpriteNode
  private let ingredientContainer: SKNode
  private var ingredientNodes: [IngredientDisplayNode] = []

  init(size: CGSize) {
    cardBackground = SKSpriteNode(imageNamed: "card")
    cardBackground.setScale(0.6)
    cardBackground.alpha = 0.5

    ingredientContainer = SKNode()

    super.init(texture: nil, color: .clear, size: size)
    setupLayout(cardSize: size)
  }

  private func setupLayout(cardSize _: CGSize) {
    addChild(cardBackground)

    ingredientContainer.position = CGPoint(x: 0, y: 10)

    addChild(ingredientContainer)

    // Set z-position
    zPosition = 100
  }

  func updateRecipeDisplay() {
    print("🔍 DEBUG: RecipeCardNode - updateRecipeDisplay called")
    // Clear existing ingredient nodes
    ingredientNodes.forEach { $0.removeFromParent() }
    ingredientNodes.removeAll()

    // Calculate remaining ingredients manually
    let currentRecipe = GameState.shared.currentRecipe
    let collectedIngredients = GameState.shared.collectedIngredients

    print("🔍 DEBUG: Current recipe: \(currentRecipe.name)")
    print("🔍 DEBUG: Recipe ingredients: \(currentRecipe.ingredients)")
    print("🔍 DEBUG: Collected ingredients: \(collectedIngredients)")

    print("🔍 DEBUG: Clearing \(ingredientNodes.count) existing ingredient nodes")
    for node in ingredientNodes {
      print("🔍 DEBUG: Removing ingredient node: \(node)")
      node.removeFromParent()
    }
    ingredientNodes.removeAll()
    print("🔍 DEBUG: All ingredient nodes cleared")

    var remainingIngredients: [Ingredient: Int] = [:]
    var totalRemaining = 0

    for (ingredient, required) in currentRecipe.ingredients {
      let collected = collectedIngredients[ingredient] ?? 0
      let remaining = max(0, required - collected)
      remainingIngredients[ingredient] = remaining
      totalRemaining += remaining
    }

    // Calculate layout
    let maxItemsPerRow = 5
    let itemWidth: CGFloat = 40
    let itemSpacing: CGFloat = 10

    let totalItems = remainingIngredients.count
    let itemsPerRow = min(totalItems, maxItemsPerRow)
    let totalWidth = CGFloat(itemsPerRow) * itemWidth + CGFloat(itemsPerRow - 1) * itemSpacing
    let startX = CGFloat(-totalWidth) / 2 + itemWidth / 2

    // Create ingredient display nodes
    var index = 0
    for (ingredient, required) in currentRecipe.ingredients {
      let remaining = remainingIngredients[ingredient] ?? 0

      let row = index / maxItemsPerRow
      let col = index % maxItemsPerRow

      let x = startX + CGFloat(col) * (itemWidth + itemSpacing)
      let y = CGFloat(-row) * 50 // Row spacing

      let ingredientNode = IngredientDisplayNode(ingredient: ingredient, count: remaining)
      ingredientNode.position = CGPoint(x: x, y: y)

      ingredientNode.alpha = (remaining == 0) ? 0.5 : 1

      ingredientContainer.addChild(ingredientNode)
      ingredientNodes.append(ingredientNode)

      index += 1
    }
  }

  func forceRefreshDisplay() {
    print("🔍 DEBUG: Force refresh display called")

    // Remove all children from ingredient container
    ingredientContainer.removeAllChildren()
    ingredientNodes.removeAll()

    print("🔍 DEBUG: Ingredient container cleared, children count: \(ingredientContainer.children.count)")

    // Call regular update
    updateRecipeDisplay()

    print("🔍 DEBUG: Force refresh completed")
  }

  // Method to verify the current state (for debugging)
  func debugCurrentState() {
    print("🔍 DEBUG: === RecipeCardNode Current State ===")
    print("🔍 DEBUG: Recipe card children: \(children.count)")
    print("🔍 DEBUG: Ingredient container children: \(ingredientContainer.children.count)")
    print("🔍 DEBUG: Ingredient nodes array: \(ingredientNodes.count)")
    print("🔍 DEBUG: Current recipe: \(GameState.shared.currentRecipe.name)")
    print("🔍 DEBUG: Collected ingredients: \(GameState.shared.collectedIngredients)")
    print("🔍 DEBUG: ==============================")
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
