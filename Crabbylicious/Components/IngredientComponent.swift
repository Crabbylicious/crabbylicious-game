//
//  IngredientComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class IngredientComponent: GKComponent {
  let ingredient: Ingredient

  init(ingredient: Ingredient) {
    self.ingredient = ingredient
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
