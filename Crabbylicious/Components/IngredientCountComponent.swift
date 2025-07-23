//
//  IngredientCountComponent.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SwiftUI

class IngredientCountComponent: GKComponent {
  let ingredient: Ingredient
  var count: Int
  var maxCount: Int

  init(ingredient: Ingredient, count: Int, maxCount: Int) {
    self.ingredient = ingredient
    self.count = count
    self.maxCount = maxCount
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
