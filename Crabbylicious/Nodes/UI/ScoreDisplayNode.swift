//
//  ScoreDisplayNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 24/07/25.
//

import SpriteKit

class ScoreDisplayNode: SKNode {
  private var scoreLabel: GameLabelNode
  private var highScoreLabel: GameLabelNode

  override init() {
    scoreLabel = GameLabelNode(text: "Score: 0", withShadow: true)
    scoreLabel.position = CGPoint(x: -30, y: 10)
    highScoreLabel = GameLabelNode(text: "High Score: 0", withShadow: true)
    highScoreLabel.position = CGPoint(x: 0, y: -10)
    super.init()
    name = "scoreDisplay"
    addChild(scoreLabel)
    addChild(highScoreLabel)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateScore(_ score: Int) {
    scoreLabel.text = "Score: \(score)"
    animateScoreIncrease()
  }
  
  func updateHighScore(_ highScore: Int) {
    highScoreLabel.text = "High Score: \(highScore)"
  }

  func updateScoreDisplay(_ score: Int) {
    scoreLabel.text = "Score: \(score)"

    // if high score beaten, update the high score label here ...
  }

  func animateScoreIncrease() {
    // Scale animation when score increases
    let scaleUp = SKAction.scale(to: 1.05, duration: 0.1)
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
    let sequence = SKAction.sequence([scaleUp, scaleDown])

    scoreLabel.run(sequence)
  }

  func animateNewHighScore() {
    // Special animation for new high score
    let scaleUp = SKAction.scale(to: 1.075, duration: 0.2)
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
    let colorize = SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.2)
    let decolorize = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.2)

    let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
    let colorSequence = SKAction.sequence([colorize, decolorize])

    let group = SKAction.group([scaleSequence, colorSequence])
    let repeatAction = SKAction.repeat(group, count: 2)

    scoreLabel.run(repeatAction)
  }
}
