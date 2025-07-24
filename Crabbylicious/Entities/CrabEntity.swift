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
  private let crabNode: CrabNode

  init(scene: SKScene, position: CGPoint, gameArea: CGRect) {
    // Create the crab node using existing CrabNode class
    crabNode = CrabNode(size: CGSize(width: 100, height: 100))
    crabNode.position = position

    super.init()
    setupCrab(scene: scene, gameArea: gameArea)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupCrab(scene: SKScene, gameArea: CGRect) {
    // Add crab node to scene
    scene.addChild(crabNode)

    // Extract leg textures and leg node from CrabNode for AnimationComponent
    let legTextures = crabNode.getLegTextures()
    let legsNode = crabNode.getLegsNode()

    // Add components
    addComponent(SpriteComponent(node: crabNode))
    addComponent(PlayerControlComponent(gameArea: gameArea))
    addComponent(AnimationComponent(legNode: legsNode, legTextures: legTextures, crabNode: crabNode))
  }
}
