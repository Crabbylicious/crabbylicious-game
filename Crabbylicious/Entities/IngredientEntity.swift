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
    super.init()
    setupIngredient(scene: scene, position: position)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupIngredient(scene: SKScene, position: CGPoint) {
    // Set position and add to scene
    ingredientNode.position = position
    scene.addChild(ingredientNode)

    // Get the existing physics body from IngredientNode
    guard let physicsBody = ingredientNode.physicsBody else {
      fatalError("IngredientNode should have a physics body")
    }

    // Apply difficulty scaling through mass and initial velocity
    let difficultyMultiplier = GameState.shared.difficultyMultiplier

    // Heavier objects fall faster in SpriteKit (counterintuitive but useful for difficulty)
    physicsBody.mass = CGFloat(difficultyMultiplier)

    // Add some random horizontal velocity
    let randomXVelocity = CGFloat.random(in: -10 ... 10)
    physicsBody.velocity = CGVector(dx: randomXVelocity, dy: 0)

    // Apply random variation to mass (±10%)
    let massVariation = CGFloat.random(in: 0.9 ... 1.1)
    physicsBody.mass *= massVariation

    // Random rotation speed for visual effect
    let rotationSpeed = CGFloat.random(in: 1.0 ... 2.0)

    // Add components using the IngredientNode
    addComponent(SpriteComponent(node: ingredientNode))
    addComponent(IngredientComponent(ingredient: ingredient))
    addComponent(PhysicsComponent(physicsBody: physicsBody))
    addComponent(FallingComponent(rotationSpeed: rotationSpeed, baseMass: physicsBody.mass))
  }
}
