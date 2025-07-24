//
//  CatchingSystem.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SpriteKit

class CatchingSystem {
  let gameState: GameState
  let scene: SKScene

  init(gameState: GameState, scene: SKScene) {
    self.gameState = gameState
    self.scene = scene
  }

  func showCorrectIndicator(on node: SKNode) {
    node.run(SKAction.sequence([
      SKAction.scale(to: 1.2, duration: 0.1),
      SKAction.scale(to: 1.0, duration: 0.1)
    ]))
  }

  func showWrongIndicator(at position: CGPoint) {
    let xMark = SKSpriteNode(imageNamed: "x_mark")
    xMark.position = position
    xMark.zPosition = 200
    scene.addChild(xMark)

    // Decrease life when wrong ingredient is caught
    gameState.decreaseLife()

    // Update life display if scene is GameScene
    if let gameScene = scene as? GameScene {
      gameScene.updateLifeDisplay()
    }

    // Check for game over
    if gameState.isGameOver() {
      if let gameScene = scene as? GameScene {
        gameScene.handleGameOverFromSystem()
      }
    }

    xMark.run(SKAction.sequence([
      SKAction.fadeOut(withDuration: 0.6),
      SKAction.removeFromParent()
    ]))
  }
}
