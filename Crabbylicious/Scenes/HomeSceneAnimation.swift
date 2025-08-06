//
//  HomeSceneAnimation.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import Foundation

extension AnimationManager {
  // MARK: - Home Scene Animations

  func animateHomeSceneEntrance(_ scene: HomeScene, completion: (() -> Void)?) {
    // Find and animate entities
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "title":
          animate(spriteComponent.node, with: .slideIn(direction: .fromTop, duration: 0.8), delay: 0.2)

        case "playButton":
          animate(spriteComponent.node, with: .bounceIn(duration: 0.6), delay: 0.6)

        case "cloud1":
          animate(spriteComponent.node, with: .bounceIn(duration: 0.6), delay: 0.6)

        case "cloud2":
          animate(spriteComponent.node, with: .bounceIn(duration: 0.6), delay: 0.6)

        default:
          break
        }
      }
    }

    // Complete after all animations
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      completion?()
    }
  }

  func animateHomeSceneExit(_ scene: HomeScene, completion: (() -> Void)?) {
    // Find and animate entities
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "titleLabel":
          animate(spriteComponent.node, with: .slideOut(direction: .fromTop, duration: 0.8), delay: 0.2)

        case "cloud1":
          animate(spriteComponent.node, with: .fadeOut(duration: 0.6), delay: 0.6)

        case "cloud2":
          animate(spriteComponent.node, with: .fadeOut(duration: 0.6), delay: 0.6)

        case "playButton":
          animate(spriteComponent.node, with: .fadeOut(duration: 0.6), delay: 0.6)

        default:
          break
        }
      }
      // Complete after all animations
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        completion?()
      }
    }
  }
}
