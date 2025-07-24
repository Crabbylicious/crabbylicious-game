//
//  IngredientDisplayNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SpriteKit

class IngredientDisplayNode: SKNode {
  private let ingredient: Ingredient
  private var count: Int

  private var ingredientSprite: SKSpriteNode!
  private var countLabel: SKLabelNode!

  init(ingredient: Ingredient, count: Int) {
    self.ingredient = ingredient
    self.count = count
    super.init()
    setupDisplay()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupDisplay() {
    // Create ingredient sprite
    ingredientSprite = SKSpriteNode(imageNamed: ingredient.imageName)
    ingredientSprite.size = CGSize(width: 40, height: 40)
    ingredientSprite.position = CGPoint(x: 0, y: 8)
    addChild(ingredientSprite)

    // Create count label
    countLabel = SKLabelNode(text: "\(count)")
    countLabel.fontName = "Press Start 2P"
    countLabel.fontSize = 12
    countLabel.fontColor = .black
    countLabel.position = CGPoint(x: 0, y: -40)
    countLabel.horizontalAlignmentMode = .center
    addChild(countLabel)
  }

  func updateCount(_ newCount: Int) {
    count = newCount
    countLabel.text = "\(count)"

    // Add visual feedback when count changes
    if count == 0 {
      let fadeAction = SKAction.fadeAlpha(to: 0.3, duration: 0.3)
      run(fadeAction)
    } else {
      // Bounce effect when count updates
      let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
      let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
      let bounce = SKAction.sequence([scaleUp, scaleDown])
      countLabel.run(bounce)
    }
  }
}
