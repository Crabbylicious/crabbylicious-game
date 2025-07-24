//
//  ScoreDisplayNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 24/07/25.
//

import SpriteKit

class ScoreDisplayNode: SKNode {
  private var scoreLabel: SKLabelNode!
  private var shadowLabel: SKLabelNode!
  private let fontSize: CGFloat = 12

  override init() {
    super.init()
    setupScoreDisplay()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupScoreDisplay() {
    scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
    scoreLabel.fontSize = fontSize
    scoreLabel.fontColor = .white
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.verticalAlignmentMode = .center
    scoreLabel.zPosition = 10

    // Add subtle shadow/outline for better visibility
    shadowLabel = SKLabelNode(fontNamed: "PressStart2P")
    shadowLabel.fontSize = fontSize
    shadowLabel.fontColor = .black
    shadowLabel.horizontalAlignmentMode = .left
    shadowLabel.verticalAlignmentMode = .center
    shadowLabel.position = CGPoint(x: 2, y: -2)
    shadowLabel.zPosition = 9
    shadowLabel.alpha = 0.7

    addChild(shadowLabel)
    addChild(scoreLabel)

    updateScoreDisplay()
  }

  func updateScoreDisplay() {
    let currentScore = GameState.shared.score
    scoreLabel.text = "Score: \(currentScore)"

    // Update shadow text too
    if let shadowLabel = children.first(where: { $0.zPosition == 9 }) as? SKLabelNode {
      shadowLabel.text = "Score: \(currentScore)"
    }
  }

  func animateScoreIncrease() {
    // Scale animation when score increases
    let scaleUp = SKAction.scale(to: 1.05, duration: 0.1)
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
    let sequence = SKAction.sequence([scaleUp, scaleDown])

    scoreLabel.run(sequence)
    shadowLabel.run(sequence)
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
    shadowLabel.run(repeatAction)
  }
}
