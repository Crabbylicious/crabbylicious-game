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
  private let ingredientNode: IngredientNode

  init(scene: SKScene, ingredient: Ingredient, position: CGPoint) {
    self.ingredient = ingredient

    ingredientNode = IngredientNode(ingredient: ingredient)
    ingredientNode.position = position

    super.init()
    setupIngredient(scene: scene)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupIngredient(scene: SKScene) {
    // Add ingredient node to scene
    scene.addChild(ingredientNode)

    // Calculate physics parameters based on difficulty
    let baseGravity: CGFloat = 400.0
    let difficultyGravity = baseGravity * CGFloat(GameState.shared.difficultyMultiplier)
    let gravityVariation = CGFloat.random(in: 0.8 ... 1.2)
    let finalGravity = difficultyGravity * gravityVariation

    let baseTerminalVelocity: CGFloat = 600.0
    let maxFallSpeed = baseTerminalVelocity * CGFloat(GameState.shared.difficultyMultiplier)
    let initialVelocity = CGFloat.random(in: 0 ... 50)
    let rotationSpeed = CGFloat.random(in: 1.0 ... 3.0)

    // Add ECS components
    addComponent(SpriteComponent(node: ingredientNode))
    addComponent(IngredientComponent(ingredient: ingredient))
    addComponent(FallingComponent(
      initialVelocity: initialVelocity,
      gravity: finalGravity,
      maxFallSpeed: maxFallSpeed,
      rotationSpeed: rotationSpeed
    ))

    // Auto-remove after 8 seconds
    addComponent(LifetimeComponent(lifetime: 8.0))
  }
}
