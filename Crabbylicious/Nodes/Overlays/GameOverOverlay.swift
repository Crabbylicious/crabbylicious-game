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

  private var background: SKSpriteNode!
  private var border: SKSpriteNode!
  private var crabDieSprite: SKSpriteNode!
  private var ohNoYouLoseLabel: SKSpriteNode!
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
    background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.6), size: CGSize(width: 1000, height: 1000))
    background.zPosition = 100
    background.name = "nextStageBackground"
    background.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2)
    addChild(background)

    border = SKSpriteNode(imageNamed: "BorderCongrats")
    border.zPosition = 101
    border.position = CGPoint(x: background.position.x, y: background.position.y - 55)
    border.setScale(0.4)
    addChild(border)

    ohNoYouLoseLabel = SKSpriteNode(imageNamed: "TextOhNoYouLose!")
    ohNoYouLoseLabel.zPosition = 102
    ohNoYouLoseLabel.position = CGPoint(x: border.position.x, y: border.position.y + 230)
    ohNoYouLoseLabel.setScale(0.4)
    addChild(ohNoYouLoseLabel)

    // Crab die sprite
    crabDieSprite = SKSpriteNode(imageNamed: "crabDie")
    crabDieSprite.position = CGPoint(x: border.position.x, y: 0)
    crabDieSprite.zPosition = 10
    crabDieSprite.setScale(0.5)
    crabDieSprite.zPosition = 102
    addChild(crabDieSprite)

    // Current Score label
    scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    scoreLabel.text = "Score: \(GameStateOld.shared.score)"
    scoreLabel.fontSize = 12
    scoreLabel.fontColor = .themeRed
    scoreLabel.position = CGPoint(x: border.position.x, y: border.position.y + 30)
    scoreLabel.zPosition = 102
    addChild(scoreLabel)

    // High Score label
    highScoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    let highScore = GameStateOld.shared.highScore
    highScoreLabel.text = "Best Score: \(highScore)"
    highScoreLabel.fontSize = 10
    highScoreLabel.fontColor = SKColor.gray
    highScoreLabel.position = CGPoint(x: overlaySize.width / 2, y: border.position.y + 10)
    highScoreLabel.zPosition = 102
    addChild(highScoreLabel)

    // Play Again button
    playAgainButton = ButtonNode(imageName: "ButtonPlayAgain")
    playAgainButton.position = CGPoint(x: overlaySize.width / 2, y: border.position.y - 33)
    playAgainButton.name = "playAgainButton"
    playAgainButton.zPosition = 102
    playAgainButton.setScale(0.25)
    addChild(playAgainButton)

    // Back Home button
    backHomeButton = ButtonNode(imageName: "ButtonBackHome")
    backHomeButton.position = CGPoint(x: overlaySize.width / 2, y: border.position.y - 88)
    backHomeButton.name = "backHomeButton"
    backHomeButton.zPosition = 102
    backHomeButton.setScale(0.25)
    addChild(backHomeButton)

    // Initially hidden
    alpha = 0
    isUserInteractionEnabled = false
  }

  func show() {
    // Update score displays with current values
    scoreLabel.text = "Score: \(GameStateOld.shared.score)"
    highScoreLabel.text = "Best Score: \(GameStateOld.shared.highScore)"

    // Check if this is a new high score and highlight it
    if GameStateOld.shared.score == GameStateOld.shared.highScore, GameStateOld.shared.score > 0 {
      // highScoreLabel.fontColor = SKColor.cyan
      highScoreLabel.text = "NEW BEST: \(GameStateOld.shared.highScore)"
    } else {
      // highScoreLabel.fontColor = SKColor.yellow
      highScoreLabel.text = "Best Score: \(GameStateOld.shared.highScore)"
    }

    isUserInteractionEnabled = true

    // Reset positions for animation
    ohNoYouLoseLabel.alpha = 0
    crabDieSprite.position.y = border.position.y + 120
    scoreLabel.alpha = 0
    highScoreLabel.alpha = 0
    playAgainButton.alpha = 0
    backHomeButton.alpha = 0

    // Animate in
    let fadeIn = SKAction.fadeIn(withDuration: 0.3)
    let crabSlideDown = SKAction.moveTo(y: border.position.y + 150, duration: 0.5)
    crabSlideDown.timingMode = .easeOut

    let textFadeIn = SKAction.fadeIn(withDuration: 0.4)
    let buttonFadeIn = SKAction.fadeIn(withDuration: 0.3)

    run(fadeIn)

    border.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.2),
      fadeIn
    ]))

    ohNoYouLoseLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      textFadeIn
    ]))

    // Animate score displays
    scoreLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.7),
      textFadeIn
    ]))

    highScoreLabel.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.8),
      textFadeIn
    ]))

    // Then animate crab
    crabDieSprite.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.3),
      crabSlideDown
    ]))

    SoundManager.sound.gameOverSound()

    // Finally animate buttons
    playAgainButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 1.0),
      buttonFadeIn
    ]))

    backHomeButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 1.2),
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
        SoundManager.sound.playInGameMusic()
        SoundManager.sound.allButtonSound()
        self.delegate?.didTapPlayAgain()
      }
    case "backHomeButton":
      animateButtonPress(touchedNode) {
        SoundManager.sound.allButtonSound()
        self.delegate?.didTapBackHome()
      }
    default:
      break
    }
  }

  private func animateButtonPress(_ button: SKNode, completion: @escaping () -> Void) {
    let scaleDown = SKAction.scale(to: 0.22, duration: 0.1)
    let scaleUp = SKAction.scale(to: 0.25, duration: 0.1)
    let sequence = SKAction.sequence([scaleDown, scaleUp, SKAction.run(completion)])

    button.run(sequence)
  }
}
