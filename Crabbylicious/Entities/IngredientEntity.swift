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
    spriteNode.setScale(0.1)
    spriteNode.position = position
    spriteNode.zPosition = 3
    scene.addChild(spriteNode)

    // Base gravity value
    let baseGravity: CGFloat = 400.0

    // Apply difficulty multiplier to gravity
    let difficultyGravity = baseGravity * CGFloat(GameState.shared.difficultyMultiplier)

    // Add random variation to gravity (±20%)
    let gravityVariation = CGFloat.random(in: 0.8 ... 1.2)
    let finalGravity = difficultyGravity * gravityVariation

    // Set terminal velocity based on difficulty
    let baseTerminalVelocity: CGFloat = 600.0
    let maxFallSpeed = baseTerminalVelocity * CGFloat(GameState.shared.difficultyMultiplier)

    // Random initial velocity (small downward push)
    let initialVelocity = CGFloat.random(in: 0 ... 50)

    // Add random rotation speed
    let rotationSpeed = CGFloat.random(in: 1.0 ... 3.0)

    // Add components
    addComponent(SpriteComponent(node: spriteNode))
    addComponent(IngredientComponent(ingredient: ingredient))
    addComponent(FallingComponent(
      initialVelocity: initialVelocity,
      gravity: finalGravity,
      maxFallSpeed: maxFallSpeed,
      rotationSpeed: rotationSpeed
    ))

    // Auto-remove after 8 seconds (increased time since they start slower)
    addComponent(LifetimeComponent(lifetime: 8.0))
  }
}
