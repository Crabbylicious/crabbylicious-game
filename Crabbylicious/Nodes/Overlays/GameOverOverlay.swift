//
//  GameOverOverlay.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 23/07/25.
//

import SpriteKit

protocol GameOverOverlayDelegate: AnyObject {
  func didTapPlayAgain()
  func didTapBackHome()
}

class GameOverOverlay: SKNode {
  weak var delegate: GameOverOverlayDelegate?

  private var backgroundOverlay: SKSpriteNode!
  private var crabDieSprite: SKSpriteNode!
  private var ohNoLabel: SKLabelNode!
  private var youLoseLabel: SKLabelNode!
  private var scoreLabel: SKLabelNode!
  private var highScoreLabel: SKLabelNode!
  private var playAgainButton: SKSpriteNode!
  private var backHomeButton: SKSpriteNode!

  private let overlaySize: CGSize

  init(size: CGSize) {
    overlaySize = size
    super.init()
    setupOverlay()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupOverlay() {
    // Semi-transparent background
    backgroundOverlay = SKSpriteNode(color: SKColor.black, size: overlaySize)
    backgroundOverlay.alpha = 0.7
    backgroundOverlay.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2)
    backgroundOverlay.zPosition = 0
    addChild(backgroundOverlay)

    // Crab die sprite
    crabDieSprite = SKSpriteNode(imageNamed: "crabDie")
    crabDieSprite.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 + 80)
    crabDieSprite.zPosition = 10
    crabDieSprite.setScale(0.5)
    addChild(crabDieSprite)

    // "OH NO!!!" label
    ohNoLabel = SKLabelNode(fontNamed: "PressStart2P")
    ohNoLabel.text = "OH NO!!!"
    ohNoLabel.fontSize = 32
    ohNoLabel.fontColor = SKColor.red
    ohNoLabel.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 + 200)
    ohNoLabel.zPosition = 10
    addChild(ohNoLabel)

    // "You Lose!" label
    youLoseLabel = SKLabelNode(fontNamed: "PressStart2P")
    youLoseLabel.text = "You Lose!"
    youLoseLabel.fontSize = 24
    youLoseLabel.fontColor = SKColor.white
    youLoseLabel.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 + 160)
    youLoseLabel.zPosition = 10
    addChild(youLoseLabel)

    // Current Score label
    scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    scoreLabel.text = "Score: \(GameState.shared.score)"
    scoreLabel.fontSize = 18
    scoreLabel.fontColor = SKColor.white
    scoreLabel.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 + 20)
    scoreLabel.zPosition = 10
    addChild(scoreLabel)

    // High Score label
    highScoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    let highScore = GameState.shared.highScore
    highScoreLabel.text = "Best: \(highScore)"
    highScoreLabel.fontSize = 16
    highScoreLabel.fontColor = SKColor.yellow
    highScoreLabel.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 - 20)
    highScoreLabel.zPosition = 10
    addChild(highScoreLabel)

    // Play Again button
    playAgainButton = ButtonNode(imageName: "buttonPlayAgain")
    playAgainButton.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 - 100)
    playAgainButton.name = "playAgainButton"
    playAgainButton.zPosition = 10
    addChild(playAgainButton)

    // Back Home button
    backHomeButton = ButtonNode(imageName: "buttonBackHome")
    backHomeButton.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 - 200)
    backHomeButton.name = "backHomeButton"
    backHomeButton.zPosition = 10
    addChild(backHomeButton)

    // Initially hidden
    alpha = 0
    isUserInteractionEnabled = false
  }

  func show() {
    // Update score displays with current values
    scoreLabel.text = "Score: \(GameState.shared.score)"
    highScoreLabel.text = "Best: \(GameState.shared.highScore)"

    // Check if this is a new high score and highlight it
    if GameState.shared.score == GameState.shared.highScore, GameState.shared.score > 0 {
      highScoreLabel.fontColor = SKColor.cyan
      highScoreLabel.text = "NEW BEST: \(GameState.shared.highScore)"
    } else {
      highScoreLabel.fontColor = SKColor.yellow
      highScoreLabel.text = "Best: \(GameState.shared.highScore)"
    }

    isUserInteractionEnabled = true

    // Reset positions for animation
    crabDieSprite.position.y = overlaySize.height / 2 + 120
    ohNoLabel.alpha = 0
    youLoseLabel.alpha = 0
    scoreLabel.alpha = 0
    highScoreLabel.alpha = 0
    playAgainButton.alpha = 0
    backHomeButton.alpha = 0

    // Animate in
    let fadeIn = SKAction.fadeIn(withDuration: 0.3)
    let crabSlideDown = SKAction.moveTo(y: overlaySize.height / 2 + 80, duration: 0.5)
    crabSlideDown.timingMode = .easeOut

    let textFadeIn = SKAction.fadeIn(withDuration: 0.4)
    let buttonFadeIn = SKAction.fadeIn(withDuration: 0.3)

    run(fadeIn)

    // Animate text labels first
    ohNoLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      textFadeIn
    ]))

    youLoseLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.2),
      textFadeIn
    ]))

    // Animate score displays
    scoreLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.4),
      textFadeIn
    ]))

    highScoreLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.5),
      textFadeIn
    ]))

    // Then animate crab
    crabDieSprite.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.3),
      crabSlideDown
    ]))

    // Finally animate buttons
    playAgainButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.7),
      buttonFadeIn
    ]))

    backHomeButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.8),
      buttonFadeIn
    ]))
  }

  func hide() {
    isUserInteractionEnabled = false
    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
    run(fadeOut)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let touchedNode = atPoint(location)

    switch touchedNode.name {
    case "playAgainButton":
      animateButtonPress(touchedNode) {
        self.delegate?.didTapPlayAgain()
      }
    case "backHomeButton":
      animateButtonPress(touchedNode) {
        self.delegate?.didTapBackHome()
      }
    default:
      break
    }
  }

  private func animateButtonPress(_ button: SKNode, completion: @escaping () -> Void) {
    let scaleDown = SKAction.scale(to: 0.38, duration: 0.2)
    let scaleUp = SKAction.scale(to: 0.42, duration: 0.2)
    let sequence = SKAction.sequence([scaleDown, scaleUp, SKAction.run(completion)])

    button.run(sequence)
  }
}
