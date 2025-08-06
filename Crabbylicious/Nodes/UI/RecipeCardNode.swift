//
//  RecipeCardNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 21/07/25.
//

import GameplayKit
import SpriteKit

class RecipeCardNode: SKNode {
  private let cardBackground: SKSpriteNode
  private var ingredients: [Ingredient: IngredientDisplayNode]

  init(recipe: Recipe) {
    cardBackground = SKSpriteNode(imageNamed: "card")
    ingredients = [:] // Initialize as empty dictionary

    super.init()
    name = "recipeCard"

    cardBackground.setScale(0.6)
    cardBackground.alpha = 0.5
    addChild(cardBackground)

    for (ingredient, count) in recipe.ingredients {
      let ingredientNode = IngredientDisplayNode(ingredient: ingredient, count: count)
      ingredients[ingredient] = ingredientNode
      addChild(ingredientNode)
    }

    layoutIngredients()
  }

  func updateRecipe(_ recipe: Recipe) {
    ingredients.forEach { $0.value.removeFromParent() }
    ingredients.removeAll()

    for (ingredient, count) in recipe.ingredients {
      let ingredientNode = IngredientDisplayNode(ingredient: ingredient, count: count)
      ingredients[ingredient] = ingredientNode
      addChild(ingredientNode)
    }

    layoutIngredients()
  }

  func updateIngredientCount(_ ingredient: Ingredient, _ count: Int) {
    ingredients[ingredient]?.updateCount(count)
  }

  private func layoutIngredients() {
    let spacing: CGFloat = 60
    let startX = -CGFloat(ingredients.count - 1) * spacing / 2

    for (index, (_, node)) in ingredients.enumerated() {
      node.position = CGPoint(
        x: startX + CGFloat(index) * spacing,
        y: 0
      )
    }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
