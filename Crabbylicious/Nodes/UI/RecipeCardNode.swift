//
//  RecipeCardNode.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 21/07/25.
//

import GameplayKit
import SpriteKit

class RecipeCardNode: SKShapeNode {
  
  private let cardBackground: SKShapeNode
  private let titleLabel: SKLabelNode
  
  init(size: CGSize) {
    
    cardBackground = SKShapeNode(rectOf: CGSize(width: size.width - 50, height: 82), cornerRadius: 30)
    cardBackground.fillColor = .white
    cardBackground.strokeColor = .clear
    cardBackground.alpha = 0.5
    
    titleLabel = SKLabelNode(text: "test")
    //titleLabel.fontName = "Press Start 2P"
    titleLabel.fontColor = .black
    titleLabel.fontSize = 24
    
    super.init()
    setupLayout(cardSize: size)
  }
  
  private func setupLayout(cardSize: CGSize) {
    
    addChild(cardBackground)
    
    titleLabel.position = CGPoint(x: 0, y: cardSize.height/4)
    addChild(titleLabel)
    
//    // Position count
//    countLabel.position = CGPoint(x: 0, y: cardSize.height/4 - 30)
//    addChild(countLabel)
//    
//    // Position ingredient container
//    ingredientContainer.position = CGPoint(x: 0, y: -cardSize.height/4)
//    addChild(ingredientContainer)
    
    // Set z-position
    zPosition = 100
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
