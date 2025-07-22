//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
  let gameArea: CGRect
  let crab: CrabNode

  // Ingredient spawning properties
  private var ingredientSpawnTimer: Timer?
  private let ingredientSpawnInterval: TimeInterval = 1.5 // seconds between spawns

  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    crab = CrabNode(size: size)

    super.init(size: size)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // make every node visible
  override func didMove(to _: SKView) {
    // Set up physics world
    physicsWorld.gravity = CGVector(dx: 0, dy: -2.8)
    physicsWorld.contactDelegate = self

    // Add background first (lowest z-position)
    let background = BackgroundNode(size: size)
    background.zPosition = 0
    addChild(background)

    // Add ground second
    let ground = GroundNode(size: size)
    ground.zPosition = 1
    addChild(ground)

    // Add crab on top
    crab.position = CGPoint(x: size.width / 2, y: size.height * 0.13)
    crab.zPosition = 2
    addChild(crab)
    
    // Ingredient card
    let recipeCard = RecipeCardNode(size: size)
    recipeCard.zPosition = 10
    recipeCard.position = CGPoint(x: size.width / 2, y: size.height - 175)
    addChild(recipeCard)

    startIngredientSpawning()
  }

  // MARK: - Ingredient Spawning

  private func startIngredientSpawning() {
    ingredientSpawnTimer = Timer.scheduledTimer(withTimeInterval: ingredientSpawnInterval, repeats: true) { _ in
      self.spawnRandomIngredient()
    }
  }

  private func stopIngredientSpawning() {
    ingredientSpawnTimer?.invalidate()
    ingredientSpawnTimer = nil
  }

  private func spawnRandomIngredient() {
    // Get a random ingredient from all available ingredients
    let randomIngredient = GameData.allIngredients.randomElement()!
    let ingredientNode = IngredientNode(ingredient: randomIngredient)

    // Random X position within game area
    let randomX = CGFloat.random(in: gameArea.minX + 50 ... gameArea.maxX - 50)

    // Start above the screen
    ingredientNode.position = CGPoint(x: randomX, y: size.height + 100)

    addChild(ingredientNode)

    // Add some random horizontal velocity for more interesting gameplay
    let randomXVelocity = CGFloat.random(in: -50 ... 50)
    ingredientNode.physicsBody?.velocity = CGVector(dx: randomXVelocity, dy: 0)
  }

  func didBegin(_ contact: SKPhysicsContact) {
    var ingredientNode: IngredientNode?
    var basketNode: SKNode?

    // Determine which node is the ingredient and which is the basket
    if contact.bodyA.categoryBitMask == PhysicsCategory.ingredient {
      ingredientNode = contact.bodyA.node as? IngredientNode
      basketNode = contact.bodyB.node
    } else if contact.bodyB.categoryBitMask == PhysicsCategory.ingredient {
      ingredientNode = contact.bodyB.node as? IngredientNode
      basketNode = contact.bodyA.node
    }

    // Handle ingredient caught by crab
    if let ingredient = ingredientNode, let _ = basketNode {
      handleIngredientCaught(ingredient)
    }
  }

  // MARK: - Physics Contact Delegate

  private func handleIngredientCaught(_ ingredientNode: IngredientNode) {
    // Remove the ingredient from the scene
    ingredientNode.removeFromParent()

    // TODO: Add ingredient to inventory
    // TODO: Check if absurd ingredient (game over logic)
    // TODO: Update score/UI
    // TODO: Add visual feedback (particles, sound, etc.)

    print("Caught ingredient: \(ingredientNode.ingredient.name)")

    if ingredientNode.ingredient.isAbsurd {
      print("Oops! Caught an absurd ingredient!")
      // TODO: Implement game over logic
    }
  }

  // MARK: - Scene Updates

  override func update(_: TimeInterval) {
    // Remove ingredients that have fallen off screen
    enumerateChildNodes(withName: "*") { node, _ in
      if let ingredientNode = node as? IngredientNode,
         ingredientNode.position.y < -100
      {
        ingredientNode.removeFromParent()
      }
    }
  }

  // crab movement
  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    for touch in touches {
      let pointOfTouch = touch.location(in: self) // where we touch the screen right now
      let previousPointOfTouch = touch.previousLocation(in: self) // where we were touching before

      let amountDragged = pointOfTouch.x - previousPointOfTouch.x

      crab.startLegAnimation()
      crab.position.x += amountDragged

      let moreMarginBowl = crab.size.width / 1.1 //

      if crab.position.x > CGRectGetMaxX(gameArea) - moreMarginBowl {
        crab.position.x = CGRectGetMaxX(gameArea) - moreMarginBowl
      }

      if crab.position.x < CGRectGetMinX(gameArea) + moreMarginBowl {
        crab.position.x = CGRectGetMinX(gameArea) + moreMarginBowl
      }
    }
  }

  override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
    crab.stopLegAnimation()
  }

  // Clean up when scene is removed
  deinit {
    stopIngredientSpawning()
  }
}
