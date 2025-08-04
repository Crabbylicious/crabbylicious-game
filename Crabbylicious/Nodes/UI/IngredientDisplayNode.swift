//
//  IngredientDisplayNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SpriteKit

class IngredientDisplayNode: SKNode {
  private let ingredientImageName: String
  private let ingredientScale: CGFloat
  private var ingredientCountNode: GameLabelNode

  init(ingredient: Ingredient, count: Int) {
    super.init()

    ingredientImageName = ingredient.imageName
    ingredientScale = ingredient.scale

    let scaledSize = 400 * ingredientScale

    let ingredientNode = SKSpriteNode(imageNamed: ingredientImageName)
    ingredientNode.size = CGSize(width: scaledSize, height: scaledSize)
    ingredientNode.position = CGPoint(x: 0, y: 8)

    addChild(ingredientNode)

    ingredientCountNode = GameLabelNode(text: "\(count)")

    addChild(ingredientCountNode)
  }

  func updateCount(_ newCount: Int) {
    ingredientCountNode.text = "\(newCount)"

    if newCount == 0 {
      let fadeAction = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
      run(fadeAction)
    } else {
      let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
      let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
      let bounce = SKAction.sequence([scaleUp, scaleDown])
      ingredientCountNode.run(bounce)
    }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
