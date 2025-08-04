//
//  IngredientNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 17/07/25.
//

import Foundation
import SpriteKit

class IngredientNode: SKSpriteNode {
  init(ingredient: Ingredient) {
    let texture = SKTexture(imageNamed: ingredient.imageName)
    super.init(texture: texture, color: .clear, size: texture.size())

    setScale(ingredient.scale)

    let physicsBody = SKPhysicsBody(circleOfRadius: 40)
    physicsBody.categoryBitMask = PhysicsCategory.ingredient
    physicsBody.contactTestBitMask = PhysicsCategory.player
    physicsBody.collisionBitMask = 0
    physicsBody.affectedByGravity = true
    physicsBody.isDynamic = true

    self.physicsBody = physicsBody
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
