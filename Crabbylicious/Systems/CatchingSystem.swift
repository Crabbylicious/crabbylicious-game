//
//  CatchingSystem.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SpriteKit

class CatchingSystem {
  let gameState: GameState
  let scene: SKScene

  init(gameState: GameState, scene: SKScene) {
    self.gameState = gameState
    self.scene = scene
  }

  func handleContact(between ingredientEntity: GKEntity) {
    guard let ingredientComp = ingredientEntity.component(ofType: IngredientComponent.self),
          let sprite = ingredientEntity.component(ofType: GKSKNodeComponent.self)?.node else { return }

    let ingredient = ingredientComp.ingredient
    let recipe = gameState.currentRecipe
    let targetAmount = recipe.ingredients.first(where: { $0.0 == ingredient })?.1 ?? 0
    let currentCaught = gameState.collectedIngredients[ingredient] ?? 0

    if targetAmount == 0 {
      showWrongIndicator(at: sprite.position)
    } else if currentCaught < targetAmount {
      gameState.collectedIngredients[ingredient] = currentCaught + 1
      showCorrectIndicator(on: sprite)
    } else {
      showWrongIndicator(at: sprite.position)
    }

    // Optionally: remove ingredient from scene
    sprite.removeFromParent()

    // Refresh UI (e.g., RecipeCardNode)
    // gameState.recipeCard.updateRecipeDisplay()
  }

  func showCorrectIndicator(on node: SKNode) {
    node.run(SKAction.sequence([
      SKAction.scale(to: 1.2, duration: 0.1),
      SKAction.scale(to: 1.0, duration: 0.1)
    ]))
  }

  func showWrongIndicator(at position: CGPoint) {
    let xMark = SKSpriteNode(imageNamed: "x_mark")
    xMark.position = position
    xMark.zPosition = 200
    scene.addChild(xMark)

    xMark.run(SKAction.sequence([
      SKAction.fadeOut(withDuration: 0.6),
      SKAction.removeFromParent()
    ]))
  }
}
