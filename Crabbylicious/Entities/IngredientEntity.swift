//
//  IngredientEntity.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class IngredientEntity: GKEntity {
  let ingredient: Ingredient

  init(scene: SKScene, ingredient: Ingredient, position: CGPoint) {
    self.ingredient = ingredient
    super.init()
    setupIngredient(scene: scene, position: position)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupIngredient(scene: SKScene, position: CGPoint) {
    // Create ingredient sprite
    let texture = SKTexture(imageNamed: ingredient.imageName)
    let spriteNode = SKSpriteNode(texture: texture)
    spriteNode.setScale(0.3)
    spriteNode.position = position
    spriteNode.zPosition = 3
    scene.addChild(spriteNode)

    // Get current fall speed from game state
    let currentFallSpeed = GameState.shared.getCurrentFallSpeed()

    // Add random variation to fall speed (±20%)
    let speedVariation = CGFloat.random(in: 0.8 ... 1.2)
    let finalFallSpeed = currentFallSpeed * speedVariation

    // Add random rotation speed
    let rotationSpeed = CGFloat.random(in: 1.0 ... 3.0)

    // Add components
    addComponent(SpriteComponent(node: spriteNode))
    addComponent(IngredientComponent(ingredient: ingredient))
    addComponent(FallingComponent(fallSpeed: finalFallSpeed, rotationSpeed: rotationSpeed))

    // Auto-remove after 6 seconds (should be enough time to fall off screen)
    addComponent(LifetimeComponent(lifetime: 6.0))
  }
}
