//
//  BackgroundLayerManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 19/07/25.
//

import Foundation
import SpriteKit

class BackgroundLayerManager: BaseLayerManager {
  // MARK: - Properties

  private var backgroundNode: BackgroundNode?
  private var groundNode: GroundNode?

  // MARK: - Template Method Implementation

  override func createNodes() {
    guard let scene else { return }

    // Create background
    backgroundNode = BackgroundNode(size: scene.size)
    backgroundNode?.zPosition = 0

    // Create ground
    groundNode = GroundNode(size: scene.size)
    groundNode?.zPosition = 1

    print("🌄 BackgroundLayerManager: Nodes created")
  }

  override func positionNodes() {
    // Background and ground position themselves in their init
    // No additional positioning needed
    print("🌄 BackgroundLayerManager: Nodes positioned")
  }

  override func addNodesToScene() {
    guard let scene else { return }

    if let background = backgroundNode {
      scene.addChild(background)
    }

    if let ground = groundNode {
      scene.addChild(ground)
    }

    print("🌄 BackgroundLayerManager: Nodes added to scene")
  }

  override func removeAllNodes() {
    backgroundNode?.removeFromParent()
    groundNode?.removeFromParent()

    backgroundNode = nil
    groundNode = nil

    print("🌄 BackgroundLayerManager: Nodes removed")
  }

  // MARK: - Touch Handling

  override func handleTouch(at _: CGPoint) -> Bool {
    // Background never consumes touches
    false
  }
}
