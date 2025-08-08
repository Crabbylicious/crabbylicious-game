//
//  HomeSceneAnimation.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import Foundation
import SpriteKit

extension AnimationManager {
  // MARK: - Home Scene Animations

  func animateHomeSceneEntrance(_ scene: HomeScene, completion: (() -> Void)?) {
    // Find and animate entities
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "title":
          animate(spriteComponent.node, with: .slideIn(direction: .fromTop, duration: 1.2), delay: 0.3)

        case "cloud1":
          animate(spriteComponent.node, with: .bounceIn(duration: 1.0), delay: 1.0)
          // Add continuous floating animation
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            let floatUp = SKAction.moveBy(x: 0, y: 10, duration: 2.0)
            floatUp.timingMode = .easeInEaseOut
            let floatDown = SKAction.moveBy(x: 0, y: -10, duration: 2.0)
            floatDown.timingMode = .easeInEaseOut
            let floatSequence = SKAction.sequence([floatUp, floatDown])
            let repeatFloat = SKAction.repeatForever(floatSequence)
            spriteComponent.node.run(repeatFloat, withKey: "cloud1Float")
          }

        case "cloud2":
          animate(spriteComponent.node, with: .bounceIn(duration: 1.0), delay: 1.3)
          // Add continuous floating animation with different timing
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let floatUp = SKAction.moveBy(x: 0, y: -8, duration: 2.5)
            floatUp.timingMode = .easeInEaseOut
            let floatDown = SKAction.moveBy(x: 0, y: 8, duration: 2.5)
            floatDown.timingMode = .easeInEaseOut
            let floatSequence = SKAction.sequence([floatUp, floatDown])
            let repeatFloat = SKAction.repeatForever(floatSequence)
            spriteComponent.node.run(repeatFloat, withKey: "cloud2Float")
          }

        case "playButton":
          animate(spriteComponent.node, with: .elastic(duration: 1.2), delay: 1.8)
          // Add a subtle pulse animation that repeats
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let pulseAction = self.createAction(for: .pulse(duration: 1.5), node: spriteComponent.node)
            let repeatPulse = SKAction.repeatForever(SKAction.sequence([pulseAction, SKAction.wait(forDuration: 2.0)]))
            spriteComponent.node.run(repeatPulse, withKey: "playButtonPulse")
          }

        default:
          break
        }
      }
    }

    // Complete after all animations (increased timing for slower, sequential animations)
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
      completion?()
    }
  }

  func animateHomeSceneExit(_ scene: HomeScene, completion: (() -> Void)?) {
    // Find and animate entities
    let entities = scene.entityManager.getEntitiesWith(componentType: SpriteComponent.self)

    for entity in entities {
      if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
        switch spriteComponent.name {
        case "playButton":
          // Stop any repeating animations
          spriteComponent.node.removeAction(forKey: "playButtonPulse")
          animate(spriteComponent.node, with: .scaleOut(duration: 0.8), delay: 0.0)

        case "cloud1":
          // Stop floating animation
          spriteComponent.node.removeAction(forKey: "cloud1Float")
          animate(spriteComponent.node, with: .fadeOut(duration: 0.8), delay: 0.2)

        case "cloud2":
          // Stop floating animation
          spriteComponent.node.removeAction(forKey: "cloud2Float")
          animate(spriteComponent.node, with: .fadeOut(duration: 0.8), delay: 0.4)

        case "titleLabel", "title":
          animate(spriteComponent.node, with: .slideOut(direction: .toTop, duration: 1.0), delay: 0.6)

        default:
          break
        }
      }
    }

    // Complete after all animations (increased timing for slower, sequential animations)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
      completion?()
    }
  }
}
