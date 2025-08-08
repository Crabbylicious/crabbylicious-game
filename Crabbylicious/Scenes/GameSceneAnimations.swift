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

    // Play bubble sound for entrance
    SoundManager.sound.bubbleSound()

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "bubbleBackground1":
          // First bubble background slides up from bottom slowly
          animate(spriteComponent.node, with: .slideIn(direction: .fromBottom, duration: 1.2), delay: 0.0)

        case "bubbleBackground2":
          // Second bubble background slides up with slight delay for layered effect
          animate(spriteComponent.node, with: .slideIn(direction: .fromBottom, duration: 1.2), delay: 0.2)

        case "crab":
          // Crab bounces in from bottom with more dramatic effect
          animate(spriteComponent.node, with: .bounceIn(duration: 1.0), delay: 1.0)
          // Add a subtle wiggle animation after entrance
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            let wiggleAction = self.createAction(for: .wiggle(duration: 0.8), node: spriteComponent.node)
            spriteComponent.node.run(wiggleAction)
          }

        case "scoreDisplay":
          // Score display fades in slowly after crab appears
          animate(spriteComponent.node, with: .fadeIn(duration: 0.8), delay: 1.5)

        case "lifeDisplay":
          // Life display fades in sequentially after score
          animate(spriteComponent.node, with: .fadeIn(duration: 0.8), delay: 1.8)

        case "ButtonPause", "pauseButton":
          // Pause button slides in from top with bounce effect
          animate(spriteComponent.node, with: .slideIn(direction: .fromTop, duration: 0.8), delay: 2.1)

        case "recipeCard":
          // Recipe card slides in from top last with elastic effect
          animate(spriteComponent.node, with: .elastic(duration: 1.2), delay: 2.4)

        default:
          break
        }
      }
    }

    // Complete after all animations (increased timing for slower, sequential animations)
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
      completion?()
    }
  }

  func animateGameSceneExit(_ scene: GameScene, completion: (() -> Void)?) {
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "recipeCard":
          // Recipe card slides out to top first
          animate(spriteComponent.node, with: .slideOut(direction: .toTop, duration: 0.6), delay: 0.0)

        case "ButtonPause", "pauseButton":
          // Pause button slides out to top
          animate(spriteComponent.node, with: .slideOut(direction: .toTop, duration: 0.5), delay: 0.2)

        case "scoreDisplay":
          // Score display fades out
          animate(spriteComponent.node, with: .fadeOut(duration: 0.6), delay: 0.4)

        case "lifeDisplay":
          // Life display fades out
          animate(spriteComponent.node, with: .fadeOut(duration: 0.6), delay: 0.5)

        case "crab":
          // Crab slides out to bottom with scaling effect
          animate(spriteComponent.node, with: .slideOut(direction: .toBottom, duration: 0.8), delay: 0.6)

        case "bubbleBackground1":
          // First bubble background slides out to bottom
          animate(spriteComponent.node, with: .slideOut(direction: .toBottom, duration: 1.0), delay: 1.0)

        case "bubbleBackground2":
          // Second bubble background slides out to bottom last
          animate(spriteComponent.node, with: .slideOut(direction: .toBottom, duration: 1.0), delay: 1.2)

        default:
          break
        }
      }
    }

    // Complete after all animations (increased timing for slower, sequential animations)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      completion?()
    }
  }
}
