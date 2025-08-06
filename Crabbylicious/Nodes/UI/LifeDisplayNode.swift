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
    name = "lifeDisplay"

    let totalWidth = 3 * heartSize.width + 2 * heartSpacing
    let startX = -totalWidth / 2 + heartSize.width / 2

    for i in 0 ..< 3 {
      let heartNode = SKSpriteNode(imageNamed: "heartFull")
      heartNode.size = heartSize
      heartNode.position = CGPoint(
        x: startX + CGFloat(i) * (heartSize.width + heartSpacing),
        y: 0
      )

      addChild(heartNode)
      heartNodes.append(heartNode)
    }
  }

  func updateHeartDisplay(_ newLives: Int) {
    for (index, heartNode) in heartNodes.enumerated() {
      if index < newLives {
        heartNode.texture = SKTexture(imageNamed: "heartFull")
      } else {
        heartNode.texture = SKTexture(imageNamed: "heartEmpty")
      }
    }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
