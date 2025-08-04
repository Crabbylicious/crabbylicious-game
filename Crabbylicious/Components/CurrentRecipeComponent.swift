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
  var currentCaughtIngredient: [Ingredient: Int] = [:]
  var isRecipeCompleted: Bool = false

  init(recipe: Recipe) {
    currentRecipe = recipe
    for (ingredient, _) in currentRecipe.ingredients {
      currentCaughtIngredient[ingredient] = 0
    }
    super.init()
  }

  func updateRecipe(_ newRecipe: Recipe) {
    currentRecipe = newRecipe
    for (ingredient, _) in currentRecipe.ingredients {
      currentCaughtIngredient[ingredient] = 0
    }
    isRecipeCompleted = false
  }

  func caughtIngredient(_ ingredient: Ingredient) {
    currentCaughtIngredient[ingredient, default: 0] += 1
    if checkRecipeCompletion() {
      isRecipeCompleted = true
    }
  }

  private func checkRecipeCompletion() -> Bool {
    currentRecipe.ingredients.allSatisfy { ingredient, count in
      currentCaughtIngredient[ingredient] == count
    }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
