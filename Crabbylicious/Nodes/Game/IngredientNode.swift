//
//  IngredientNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 17/07/25.
//

import Foundation
import SpriteKit

class IngredientNode: SKSpriteNode {
  let ingredient: Ingredient

  init(ingredient: Ingredient) {
    self.ingredient = ingredient
    let texture = SKTexture(imageNamed: ingredient.imageName)
    super.init(texture: texture, color: .clear, size: texture.size())

    setScale(0.1)
    zPosition = 3
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
