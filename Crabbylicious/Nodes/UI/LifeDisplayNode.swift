//
//  LifeDisplayNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 23/07/25.
//

import SpriteKit

class LifeDisplayNode: SKNode {
  private var heartNodes: [SKSpriteNode] = []
  private let heartSize: CGSize = .init(width: 24, height: 24)
  private let heartSpacing: CGFloat = 8

  override init() {
    super.init()
    setupHeartDisplay()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupHeartDisplay() {
    let maxLives = GameStateOld.shared.maxLives
    let totalWidth = CGFloat(maxLives) * heartSize.width + CGFloat(maxLives - 1) * heartSpacing
    let startX = -totalWidth / 2 + heartSize.width / 2

    for i in 0 ..< maxLives {
      let heartNode = SKSpriteNode(imageNamed: "heartFull")
      heartNode.size = heartSize
      heartNode.position = CGPoint(
        x: startX + CGFloat(i) * (heartSize.width + heartSpacing),
        y: 0
      )
      heartNode.zPosition = 10

      addChild(heartNode)
      heartNodes.append(heartNode)
    }

    updateHeartDisplay()
  }

  func updateHeartDisplay() {
    let currentLives = GameStateOld.shared.lives

    for (index, heartNode) in heartNodes.enumerated() {
      if index < currentLives {
        heartNode.texture = SKTexture(imageNamed: "heartFull")
      } else {
        heartNode.texture = SKTexture(imageNamed: "heartEmpty")
      }
    }
  }

  func animateLifeLoss() {
    guard GameStateOld.shared.lives < heartNodes.count else { return }

    let lostHeartIndex = GameStateOld.shared.lives // Index of the heart that was lost
    let heartNode = heartNodes[lostHeartIndex]

    // Animate the heart loss
    let scaleUp = SKAction.scale(to: 1.3, duration: 0.1)
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
    let changeTexture = SKAction.run {
      heartNode.texture = SKTexture(imageNamed: "heartEmpty")
    }

    let sequence = SKAction.sequence([scaleUp, changeTexture, scaleDown])
    heartNode.run(sequence)
  }
}
