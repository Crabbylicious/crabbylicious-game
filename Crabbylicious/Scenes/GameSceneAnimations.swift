//
//  GameSceneAnimations.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import Foundation

extension AnimationManager {
  func animateGameSceneEntrance(_ scene: GameScene, completion: (() -> Void)? = nil) {
    // Find and animate entities
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "bubbleBackground1", "bubbleBackground2":
          // Bubble background slides up from bottom to fill the scene
          animate(spriteComponent.node, with: .slideIn(direction: .fromBottom, duration: 0.8), delay: 0.0)

        case "crab":
          // Crab slides in from bottom for smooth transition
          animate(spriteComponent.node, with: .slideIn(direction: .fromBottom, duration: 0.4), delay: 0.3)

        case "scoreDisplay":
          // Score display fades in quickly
          animate(spriteComponent.node, with: .fadeIn(duration: 0.3), delay: 0.4)

        case "lifeDisplay":
          // Life display fades in quickly
          animate(spriteComponent.node, with: .fadeIn(duration: 0.3), delay: 0.45)

        case "ButtonPause", "pauseButton":
          // Pause button slides in from top
          animate(spriteComponent.node, with: .slideIn(direction: .fromTop, duration: 0.3), delay: 0.4)

        case "recipeCard":
          // Recipe card slides in from top
          animate(spriteComponent.node, with: .slideIn(direction: .fromTop, duration: 0.4), delay: 0.5)

        default:
          break
        }
      }
    }

    // Complete after all animations
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
      completion?()
    }
  }

  func animateGameSceneExit(_ scene: GameScene, completion: (() -> Void)?) {
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self),
         spriteComponent.name == "pauseButton"
      {
        animate(spriteComponent.node, with: .slideOut(direction: .toTop, duration: 0.3), delay: 0.0)
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      completion?()
    }
  }
}
