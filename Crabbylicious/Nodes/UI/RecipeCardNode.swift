//
//  RecipeCardNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 21/07/25.
//

import GameplayKit
import SpriteKit

class RecipeCardNode: SKSpriteNode {
  
  private let cardBackground: SKShapeNode
  private let countLabel: SKLabelNode
  private let ingredientContainer: SKNode
  private var ingredientNodes: [IngredientDisplayNode] = []
  
  init(size: CGSize) {
    
    cardBackground = SKShapeNode(rectOf: CGSize(width: size.width - 110, height: 120), cornerRadius: 30)
    cardBackground.fillColor = .white
    cardBackground.strokeColor = .clear
    cardBackground.alpha = 0.5
    
    countLabel = SKLabelNode(text: "")
    countLabel.fontName = "Press Start 2P"
    countLabel.fontColor = .black
    countLabel.fontSize = 13
    
    ingredientContainer = SKNode()
    
    super.init(texture: nil, color: .clear, size: size)
    setupLayout(cardSize: size)
  }
  
  private func setupLayout(cardSize: CGSize) {
    
    addChild(cardBackground)
    
    countLabel.position = CGPoint(x: 0, y: 23)
    addChild(countLabel)
    
    ingredientContainer.position = CGPoint(x: 0, y: -18)
    addChild(ingredientContainer)
    
    // Set z-position
    zPosition = 100
  }
  
  func updateRecipeDisplay() {
    // Clear existing ingredient nodes
    ingredientNodes.forEach { $0.removeFromParent() }
    ingredientNodes.removeAll()
    
    // Update recipe name label
    //let recipeName = GameState.shared.currentRecipe.name
    let remainingIngredients = GameState.shared.getRemainingIngredients()
    let totalRemaining = remainingIngredients.values.reduce(0, +)
    countLabel.text = "\(totalRemaining) left"
    
    // Get remaining ingredients
    
    // Filter out ingredients with 0 count
    //let activeIngredients = remainingIngredients.filter { $0.value > 0 }
    
    let activeIngredients = remainingIngredients
    let allIngredients = GameState.shared.currentRecipe.ingredients
    
    // Calculate layout
    let maxItemsPerRow = 5
    let itemWidth: CGFloat = 40
    let itemSpacing: CGFloat = 8
    
    let totalItems = activeIngredients.count
    let itemsPerRow = min(totalItems, maxItemsPerRow)
    let totalWidth = CGFloat(itemsPerRow) * itemWidth + CGFloat(itemsPerRow - 1) * itemSpacing
    let startX = CGFloat(-totalWidth) / 2 + itemWidth / 2
    
    // Create ingredient display nodes
    var index = 0
    for (ingredient, _) in GameState.shared.currentRecipe.ingredients {
      
      let count = remainingIngredients[ingredient] ?? 0
      
      let row = index / maxItemsPerRow
      let col = index % maxItemsPerRow
      
      let x = startX + CGFloat(col) * (itemWidth + itemSpacing)
      let y = CGFloat(-row) * 50 // Row spacing
      
      let ingredientNode = IngredientDisplayNode(ingredient: ingredient, count: count)
      ingredientNode.position = CGPoint(x: x, y: y)
      
      ingredientContainer.addChild(ingredientNode)
      ingredientNodes.append(ingredientNode)
      
      index += 1
    }
    
    // Adjust card height if needed for multiple rows
    //let rows = (activeIngredients.count + maxItemsPerRow - 1) / maxItemsPerRow
    //let newHeight = max(103, CGFloat(rows) * 50 + 53)
    
  }


  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
