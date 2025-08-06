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
  private var ingredients: [Ingredient: IngredientDisplayNode]!

  init(recipe: Recipe) {
    cardBackground = SKSpriteNode(imageNamed: "card")
    cardBackground.setScale(0.6)
    cardBackground.alpha = 0.5

    super.init()
    name = "recipeCard"
    addChild(cardBackground)

    for (ingredient, count) in recipe.ingredients {
      let ingredientNode = IngredientDisplayNode(ingredient: ingredient, count: count)
      ingredients[ingredient] = ingredientNode
      addChild(ingredientNode)
    }
  }

  func updateRecipe(_ recipe: Recipe) {
    ingredients.removeAll()

    for (ingredient, count) in recipe.ingredients {
      let ingredientNode = IngredientDisplayNode(ingredient: ingredient, count: count)
      ingredients[ingredient] = ingredientNode
      addChild(ingredientNode)
    }
  }

  func updateIngredientCount(_ ingredient: Ingredient, _ count: Int) {
    ingredients[ingredient]?.updateCount(count)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
