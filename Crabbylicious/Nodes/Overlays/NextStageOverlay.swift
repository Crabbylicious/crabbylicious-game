//
//  NextStageOverlay.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 23/07/25.
//

import SpriteKit

class NextStageOverlay: SKNode {
  
  init(recipe: Recipe) {
    super.init()
    setupOverlay(recipe: recipe)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupOverlay(recipe: Recipe) {
    // Background
    let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: CGSize(width: 1000, height: 1000))
    background.zPosition = 100
    background.name = "nextStageBackground"
    background.position = .zero
    addChild(background)

    // Congratulations Label
    let label = SKLabelNode(text: "CONGRATULATIONS!")
    label.fontName = "Press Start 2P"
    label.fontSize = 20
    label.fontColor = .white
    label.position = CGPoint(x: 0, y: 150)
    label.zPosition = 101
    addChild(label)

    // Crab with the finished dish
    let finishedDish = SKSpriteNode(imageNamed: recipe.name)
    finishedDish.name = "finishedDish"
    finishedDish.setScale(0.5)
    finishedDish.position = CGPoint(x: 0, y: 0)
    finishedDish.zPosition = 101
    addChild(finishedDish)
    
    // recipe label
    let recipeLabel = SKLabelNode(text: "\(recipe.name) done!")
    recipeLabel.fontName = "Press Start 2P"
    recipeLabel.fontSize = 20
    recipeLabel.fontColor = .white
    recipeLabel.position = CGPoint(x: 0, y: -180)
    recipeLabel.zPosition = 101
    addChild(recipeLabel)
    
    // Menu Button
    let nextStage = SKSpriteNode(imageNamed: "ButtonNextStage")
    nextStage.name = "nextStageButton"
    nextStage.position = CGPoint(x: 0, y: -240)
    nextStage.setScale(0.3)
    nextStage.zPosition = 101
    addChild(nextStage)
  }
}
