//
//  CrabEntity.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class CrabEntity: GKEntity {
  init(scene: SKScene, position: CGPoint, gameArea: CGRect) {
    super.init()
    setupCrab(scene: scene, position: position, gameArea: gameArea)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupCrab(scene: SKScene, position: CGPoint, gameArea: CGRect) {
    // Create crab sprite
    let texture = SKTexture(imageNamed: "crabAndBowl")
    let spriteNode = SKSpriteNode(texture: texture)
    spriteNode.setScale(0.2)
    spriteNode.position = position
    spriteNode.zPosition = 2
    scene.addChild(spriteNode)

    // Create leg animation sprites
    let atlas = SKTextureAtlas(named: "Legs")
    let legTextures = [
      atlas.textureNamed("leg1"),
      atlas.textureNamed("leg2")
    ]
    let legsNode = SKSpriteNode(texture: legTextures[0])
    legsNode.setScale(0.6)
    legsNode.position = CGPoint(x: 0, y: -spriteNode.size.height * 1.9)
    legsNode.zPosition = 3
    spriteNode.addChild(legsNode)

    // Add components
    addComponent(SpriteComponent(node: spriteNode))
    addComponent(PlayerControlComponent(gameArea: gameArea))
    addComponent(AnimationComponent(legNode: legsNode, legTextures: legTextures))
  }
}
