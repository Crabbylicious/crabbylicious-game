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
  private var finishedDish: SKSpriteNode!
  private var label: SKLabelNode!
  private var recipeLabel: SKLabelNode!
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

    // Congratulations Label
    label = SKLabelNode(text: "CONGRATULATIONS!")
    label.fontName = "Press Start 2P"
    label.fontSize = 20
    label.fontColor = .white
    label.position = CGPoint(x: 0, y: 225)
    label.zPosition = 101
    addChild(label)

    // Crab with the finished dish
    finishedDish = SKSpriteNode(imageNamed: recipe.name)
    finishedDish.name = "finishedDish"
    finishedDish.setScale(0.5)
    finishedDish.position = CGPoint(x: 0, y: 0)
    finishedDish.zPosition = 101
    addChild(finishedDish)

    // recipe label
    recipeLabel = SKLabelNode(text: "\(recipe.name) done!")
    recipeLabel.fontName = "Press Start 2P"
    recipeLabel.fontSize = 20
    recipeLabel.fontColor = .white
    recipeLabel.position = CGPoint(x: 0, y: -180)
    recipeLabel.zPosition = 101
    addChild(recipeLabel)

    // Menu Button
    nextStage = ButtonNode(imageName: "ButtonNextStage")
    nextStage.name = "nextStageButton"
    nextStage.position = CGPoint(x: 0, y: -240)
    nextStage.setScale(0.3)
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

    label.alpha = 0
    recipeLabel.alpha = 0
    nextStage.alpha = 0
    finishedDish.alpha = 1
    finishedDish.position.y = 0

    print("🟢 Starting animations...")

    let fadeIn = SKAction.fadeIn(withDuration: 0.3)

    let crabSlideDown = SKAction.moveTo(y: 30, duration: 0.5)
    // crabSlideDown.timingMode = .easeOut

    let textFadeIn = SKAction.fadeIn(withDuration: 0.4)
    let buttonFadeIn = SKAction.fadeIn(withDuration: 0.3)

    background.run(fadeIn) {
      print("🟢 Background animation completed")
    }

    label.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      textFadeIn
    ]))

    finishedDish.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.3),
      crabSlideDown
    ]))

    recipeLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.5),
      textFadeIn
    ]))

    nextStage.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
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

    print("🟢 Moved to next recipe: \(GameState.shared.currentRecipe.name)")
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
