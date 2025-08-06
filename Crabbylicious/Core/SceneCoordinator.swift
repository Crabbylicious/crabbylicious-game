//
//  SceneCoordinator.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import Foundation
import SpriteKit

enum SceneType {
  case home, game
}

class SceneCoordinator {
  static let shared = SceneCoordinator()
  private var currentView: SKView?

  private init() {}

  func setView(_ view: SKView) {
    currentView = view
  }

  func transitionWithAnimation(
    to sceneType: SceneType,
    transition: SKTransition = SKTransition.fade(withDuration: 0.5)
  ) {
    guard let view = currentView else { return }

    // Get current scene for exit animation
    if let currentScene = view.scene {
      print("🎬 Starting scene transition with animations")

      // Animate current scene exit
      AnimationManager.shared.animateSceneExit(for: currentScene) {
        self.performTransition(to: sceneType, transition: transition, view: view)
      }
    } else {
      performTransition(to: sceneType, transition: transition, view: view)
    }
  }

  private func performTransition(
    to sceneType: SceneType,
    transition: SKTransition,
    view: SKView
  ) {
    let newScene: SKScene = switch sceneType {
    case .home:
      HomeScene()
    case .game:
      GameScene()
    }

    newScene.size = view.bounds.size
    newScene.scaleMode = .aspectFill

    // Present new scene
    view.presentScene(newScene, transition: transition)

    // Animate new scene entrance - already handled on each scene
  }
}
