//
//  NextStageOverlay.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 23/07/25.
//

import SpriteKit

class NextStageOverlay: SKNode {
  private var recipeCard: RecipeCardNode!
  private weak var gameScene: GameScene?

  private var background: SKSpriteNode!
  private var congratulations: SKSpriteNode!
  private var border: SKSpriteNode!
  private var finishedDish: SKSpriteNode!
  private var recipeLabel: SKLabelNode!
  private var scorelabel: SKLabelNode!
  private var nextStage: ButtonNode!

  init(recipe: Recipe, gameScene: GameScene) {
    super.init()
    self.gameScene = gameScene
    setupOverlay(recipe: recipe)
    isUserInteractionEnabled = true
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    // super.init(coder: aDecoder)
    nil
  }

  private func setupOverlay(recipe: Recipe) {
    // Background
    background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: CGSize(width: 1000, height: 1000))
    background.zPosition = 100
    background.name = "nextStageBackground"
    background.position = .zero
    addChild(background)

    border = SKSpriteNode(imageNamed: "BorderCongrats")
    border.zPosition = 101
    border.position = CGPoint(x: 0, y: -55)
    border.setScale(0.4)
    addChild(border)

    congratulations = SKSpriteNode(imageNamed: "TextCongratulations")
    congratulations.zPosition = 101
    congratulations.position = CGPoint(x: border.position.x, y: border.position.y + 290)
    congratulations.setScale(0.35)
    addChild(congratulations)

    // Crab with the finished dish
    finishedDish = SKSpriteNode(imageNamed: recipe.name)
    finishedDish.name = "finishedDish"
    finishedDish.setScale(0.5)
    finishedDish.zPosition = 102
    addChild(finishedDish)

    // recipe label
    recipeLabel = SKLabelNode(text: "\(GameStateOld.shared.currentRecipe.name) done")
    recipeLabel.fontName = "Press Start 2P"
    recipeLabel.fontSize = 12
    recipeLabel.fontColor = .themeRed
    recipeLabel.position = CGPoint(x: 0, y: border.position.y - 15)
    recipeLabel.zPosition = 101
    addChild(recipeLabel)

    scorelabel = SKLabelNode(text: "Score: \(GameStateOld.shared.score)")
    scorelabel.fontName = "Press Start 2P"
    scorelabel.fontSize = 10
    scorelabel.fontColor = .gray
    scorelabel.position = CGPoint(x: 0, y: border.position.y - 35)
    scorelabel.zPosition = 101
    addChild(scorelabel)

    // Menu Button
    nextStage = ButtonNode(imageName: "ButtonNextStage")
    nextStage.name = "nextStageButton"
    nextStage.position = CGPoint(x: 0, y: border.position.y - 80)
    nextStage.setScale(0.25)
    nextStage.zPosition = 101

    nextStage.onButtonTapped = { [weak self] in
      self?.handleNextStageButtonTapped()
    }

    addChild(nextStage)
  }

  func show() {
    print("🟢 NextStageOverlay show() called")
    isUserInteractionEnabled = true

    alpha = 1

    border.alpha = 0
    congratulations.alpha = 0
    finishedDish.alpha = 0
    recipeLabel.alpha = 0
    nextStage.alpha = 0
    finishedDish.alpha = 0
    finishedDish.position.y = border.position.y + 115

    print("🟢 Starting animations...")

    let fadeIn = SKAction.fadeIn(withDuration: 0.3)

    let crabSlideDown = SKAction.moveTo(y: border.position.y + 145, duration: 0.5)
    crabSlideDown.timingMode = .easeOut

    let textFadeIn = SKAction.fadeIn(withDuration: 0.4)
    let buttonFadeIn = SKAction.fadeIn(withDuration: 0.3)

    background.run(fadeIn) {
      print("🟢 Background animation completed")
    }

    border.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.2),
      fadeIn
    ]))

    congratulations.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),

      textFadeIn
    ]))

    finishedDish.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.3),
      fadeIn,
      crabSlideDown
    ]))

    recipeLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.7),
      textFadeIn
    ]))

    scorelabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.8),
      textFadeIn
    ]))

    nextStage.run(SKAction.sequence([
      SKAction.wait(forDuration: 1.0),
      buttonFadeIn
    ]))

    SoundManager.sound.winSound()
  }

  private func handleNextStageButtonTapped() {
    print("🟢 Next Stage button tapped!")

    gameScene?.proceedToNextStage()

    // Remove this overlay
    removeFromParent()

    // Resume the game if it was paused
    gameScene?.isPaused = false
  }

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = nodes(at: location)

    for node in nodes {
      if let buttonNode = node as? ButtonNode {
        SoundManager.sound.allButtonSound()
        SoundManager.sound.playInGameMusic()
        buttonNode.handleButtonPressed(button: buttonNode)
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = nodes(at: location)

    for node in nodes {
      if let buttonNode = node as? ButtonNode {
        buttonNode.handleButtonReleased(button: buttonNode)
      }
    }
  }
}
