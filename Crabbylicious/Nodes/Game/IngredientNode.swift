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

    // Set up physics body for collision detection
    physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    physicsBody?.categoryBitMask = PhysicsCategory.ingredient
    physicsBody?.contactTestBitMask = PhysicsCategory.basket
    physicsBody?.collisionBitMask = 0
    physicsBody?.affectedByGravity = true
    physicsBody?.isDynamic = true

    zPosition = 3
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
