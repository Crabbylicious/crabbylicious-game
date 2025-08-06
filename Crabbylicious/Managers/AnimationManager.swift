//
//  AnimationManager.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import SpriteKit

class AnimationManager {
  static let shared = AnimationManager()

  private init() {}

  // MARK: - Scene Transition Animations

  enum SlideDirection {
    case fromLeft, fromRight, fromTop, fromBottom
    case toLeft, toRight, toTop, toBottom
  }

  enum AnimationPreset {
    case slideIn(direction: SlideDirection, duration: TimeInterval = 0.5)
    case slideOut(direction: SlideDirection, duration: TimeInterval = 0.5)
    case fadeIn(duration: TimeInterval = 0.5)
    case fadeOut(duration: TimeInterval = 0.5)
    case scaleIn(duration: TimeInterval = 0.5)
    case scaleOut(duration: TimeInterval = 0.5)
    case bounceIn(duration: TimeInterval = 0.6)
    case elastic(duration: TimeInterval = 0.8)
  }

  // MARK: - Single Node Animation

  func animate(
    _ node: SKNode,
    with preset: AnimationPreset,
    delay: TimeInterval,
    completion: (() -> Void)? = nil
  ) {
    let action = createAction(for: preset, node: node)

    if delay > 0 {
      let sequence = SKAction.sequence([SKAction.wait(forDuration: delay), action])
      node.run(sequence, completion: completion ?? {})
    } else {
      node.run(action, completion: completion ?? {})
    }
  }

  // MARK: - Batch Node Animation

  func animateNodes(
    _ nodes: [SKNode],
    with preset: AnimationPreset,
    staggerDelay: TimeInterval = 0.1,
    completion: (() -> Void)? = nil
  ) {
    var completedAnimations = 0
    let totalAnimations = nodes.count

    for (index, node) in nodes.enumerated() {
      let delay = TimeInterval(index) * staggerDelay

      animate(node, with: preset, delay: delay) {
        completedAnimations += 1
        if completedAnimations == totalAnimations {
          completion?()
        }
      }
    }
  }

  // MARK: - Scene Entrance Animation

  func animateSceneEntrance(for scene: SKScene, completion: (() -> Void)? = nil) {
    if scene is HomeScene {
      animateHomeSceneEntrance(scene as! HomeScene, completion: completion)
    } else if scene is GameScene {
      animateGameSceneEntrance(scene as! GameScene, completion: completion)
    }
  }

  // MARK: - Scene Exit Animation

  func animateSceneExit(for scene: SKScene, completion: (() -> Void)? = nil) {
    if scene is HomeScene {
      animateHomeSceneExit(scene as! HomeScene, completion: completion)
    } else if scene is GameScene {
      animateGameSceneExit(scene as! GameScene, completion: completion)
    }
  }

  // MARK: - Private Implementation

  private func createAction(for preset: AnimationPreset, node: SKNode) -> SKAction {
    switch preset {
    case let .slideIn(direction, duration):
      return createSlideInAction(direction: direction, duration: duration, for: node)

    case let .slideOut(direction, duration):
      return createSlideOutAction(direction: direction, duration: duration, for: node)

    case let .fadeIn(duration):
      node.alpha = 0
      return SKAction.fadeIn(withDuration: duration)

    case let .fadeOut(duration):
      return SKAction.fadeOut(withDuration: duration)

    case let .scaleIn(duration):
      node.setScale(0)
      let scale = SKAction.scale(to: 1.0, duration: duration)
      scale.timingMode = .easeOut
      return scale

    case let .scaleOut(duration):
      let scale = SKAction.scale(to: 0, duration: duration)
      scale.timingMode = .easeIn
      return scale

    case let .bounceIn(duration):
      node.setScale(0)
      let scaleUp = SKAction.scale(to: 1.2, duration: duration * 0.6)
      scaleUp.timingMode = .easeOut
      let scaleDown = SKAction.scale(to: 1.0, duration: duration * 0.4)
      scaleDown.timingMode = .easeInEaseOut
      return SKAction.sequence([scaleUp, scaleDown])

    case let .elastic(duration):
      node.setScale(0)
      let elastic = SKAction.scale(to: 1.0, duration: duration)
      elastic.timingMode = .easeOut
      return elastic
    }
  }

  private func createSlideInAction(direction: SlideDirection, duration: TimeInterval, for node: SKNode) -> SKAction {
    guard let scene = node.scene else { return SKAction() }

    let originalPosition = node.position
    let startPosition: CGPoint = switch direction {
    case .fromLeft:
      CGPoint(x: -node.frame.width, y: originalPosition.y)
    case .fromRight:
      CGPoint(x: scene.size.width + node.frame.width, y: originalPosition.y)
    case .fromTop:
      CGPoint(x: originalPosition.x, y: scene.size.height + node.frame.height)
    case .fromBottom:
      CGPoint(x: originalPosition.x, y: -node.frame.height)
    default:
      originalPosition
    }

    let move = SKAction.move(to: originalPosition, duration: duration)
    move.timingMode = .easeOut

    node.position = startPosition
    return move
  }

  private func createSlideOutAction(direction: SlideDirection, duration: TimeInterval, for node: SKNode) -> SKAction {
    guard let scene = node.scene else { return SKAction() }

    let endPosition: CGPoint = switch direction {
    case .toLeft:
      CGPoint(x: -node.frame.width, y: node.position.y)
    case .toRight:
      CGPoint(x: scene.size.width + node.frame.width, y: node.position.y)
    case .toTop:
      CGPoint(x: node.position.x, y: scene.size.height + node.frame.height)
    case .toBottom:
      CGPoint(x: node.position.x, y: -node.frame.height)
    default:
      node.position
    }

    let move = SKAction.move(to: endPosition, duration: duration)
    move.timingMode = .easeIn
    return move
  }
}
