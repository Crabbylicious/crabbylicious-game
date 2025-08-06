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
        case "crab":
          animate(spriteComponent.node, with: .slideIn(direction: .fromLeft, duration: 0.6), delay: 0.1)

        case "scoreDisplay":
          animate(spriteComponent.node, with: .slideIn(direction: .fromRight, duration: 0.5), delay: 0.1)

        case "ButtonPause":
          animate(spriteComponent.node, with: .slideIn(direction: .fromRight, duration: 0.5), delay: 0.1)

        default:
          break
        }
      }
    }

    // Complete after all animations
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
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
