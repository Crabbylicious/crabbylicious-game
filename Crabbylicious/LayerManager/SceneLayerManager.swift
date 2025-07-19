//
//  SceneLayerManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 19/07/25.
//

import Foundation
import SpriteKit

// MARK: - Protocol

protocol SceneLayerManager: AnyObject {
  func setup(in scene: SKScene, gameArea: CGRect)
  func teardown()
  func handleTouch(at location: CGPoint) -> Bool
  func update(deltaTime: TimeInterval)
}

// MARK: - Base Implementation

class BaseLayerManager: SceneLayerManager {
  // MARK: - Properties

  weak var scene: SKScene?
  var gameArea: CGRect = .zero
  var isActive: Bool = true

  // MARK: - Lifecycle

  func setup(in scene: SKScene, gameArea: CGRect) {
    self.scene = scene
    self.gameArea = gameArea

    createNodes()
    positionNodes()
    addNodesToScene()
  }

  func teardown() {
    removeAllNodes()
    scene = nil
  }

  // MARK: - Touch Handling

  func handleTouch(at _: CGPoint) -> Bool {
    // Base implementation returns false (doesn't consume touch)
    false
  }

  // MARK: - Update

  func update(deltaTime _: TimeInterval) {
    // Base implementation does nothing
    // Override in subclasses that need updates
  }

  // MARK: - Template Methods (Override in subclasses)

  /// Override to create your layer's nodes
  func createNodes() {
    // Override in subclasses
  }

  /// Override to position your layer's nodes
  func positionNodes() {
    // Override in subclasses
  }

  /// Override to add nodes to the scene
  func addNodesToScene() {
    // Override in subclasses
  }

  /// Override to remove nodes from scene
  func removeAllNodes() {
    // Override in subclasses
  }
}
