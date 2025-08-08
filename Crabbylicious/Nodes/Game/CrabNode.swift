//
//  CrabNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class CrabNode: SKSpriteNode {
  init(size: CGSize) {
    let texture = SKTexture(imageNamed: "crab_1")

    super.init(texture: texture, color: .clear, size: texture.size())
    setScale(0.2)
    name = "crab"
    zPosition = 5

    // Create physics body only for the upper portion of the crab (top shell area)
    // This ensures ingredients are only caught when they land on top, not from sides
    let physicsBody = SKPhysicsBody(
      rectangleOf: CGSize(width: size.width * 0.8, height: size.height * 0.05), // Smaller height, focused on top
      center: CGPoint(x: 0, y: size.height * 0.5) // Positioned at the top of the crab
    )

    physicsBody.categoryBitMask = PhysicsCategory.player
    physicsBody.contactTestBitMask = PhysicsCategory.ingredient
    physicsBody.collisionBitMask = 0 // tidak saling dorong
    physicsBody.isDynamic = false // crab tidak terdorong oleh ingredient
    physicsBody.affectedByGravity = false

    self.physicsBody = physicsBody
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
