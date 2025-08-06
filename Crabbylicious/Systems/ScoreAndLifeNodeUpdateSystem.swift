//
//  UIUpdateSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import GameplayKit
import SpriteKit

class ScoreAndLifeNodeUpdateSystem: System {
  
  func update(deltaTime: TimeInterval, context: GameContext) {
     updateScoreDisplay(context: context)
     updateLifeDisplay(context: context)
  }
  
  private func updateScoreDisplay(context: GameContext) {
    // Find score entity and component
    guard let scoreEntity = context.entityManager.getEntitiesWith(componentType: ScoreComponent.self).first,
          let scoreComponent = scoreEntity.component(ofType: ScoreComponent.self),
          let spriteComponent = scoreEntity.component(ofType: SpriteComponent.self),
          let scoreDisplayNode = spriteComponent.node as? ScoreDisplayNode else { return }
    
    // Update GameState with current score if it changed
    if scoreComponent.hasChanged {
      context.gameState.updateScore(scoreComponent.score)
      scoreDisplayNode.updateScore(scoreComponent.score)
      scoreComponent.hasChanged = false
    }
  }
  
  private func updateLifeDisplay(context: GameContext) {
    // Find life entity and component  
    guard let lifeEntity = context.entityManager.getEntitiesWith(componentType: LifeComponent.self).first,
          let lifeComponent = lifeEntity.component(ofType: LifeComponent.self),
          let spriteComponent = lifeEntity.component(ofType: SpriteComponent.self),
          let lifeDisplayNode = spriteComponent.node as? LifeDisplayNode else { return }
    
    // Update life display if it changed
    if lifeComponent.hasChanged {
      lifeDisplayNode.updateHeartDisplay(lifeComponent.currentLives)
      lifeComponent.hasChanged = false
    }
  }
}
