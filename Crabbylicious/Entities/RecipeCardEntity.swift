//
//  RecipeCardEntity.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class RecipeCardEntity: GKEntity {
  private let recipeCardNode: RecipeCardNode

  init(scene: SKScene, size: CGSize, position: CGPoint) {
    recipeCardNode = RecipeCardNode(size: size)
    super.init()
    setupRecipeCard(scene: scene, position: position)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupRecipeCard(scene: SKScene, position: CGPoint) {
    // Set position and add to scene
    recipeCardNode.position = position
    scene.addChild(recipeCardNode)

    // Add components following your existing pattern
    addComponent(SpriteComponent(node: recipeCardNode))
    addComponent(RecipeDisplayComponent())
    
    // Initial display update
    updateDisplay()
  }
  
  func updateDisplay() {
    recipeCardNode.updateRecipeDisplay()
  }
}
