//
//  OverlayManagementSystem.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import GameplayKit
import SpriteKit

class OverlayManagementSystem: System, GameOverOverlayDelegate, NextStageOverlayDelegate {
  private var nextStageOverlay: NextStageOverlay?
  private var gameOverOverlay: GameOverOverlay?
  private var context: GameContext?

  func update(deltaTime _: TimeInterval, context: GameContext) {
    self.context = context

    // Check if we need to show next stage overlay
    if context.gameState.shouldShowNextStageOverlay, nextStageOverlay == nil {
      showNextStageOverlay(context: context)
    }

    // Check if we need to show game over overlay
    if context.gameState.shouldShowGameOverOverlay, gameOverOverlay == nil {
      showGameOverOverlay(context: context)
    }
  }

  private func showNextStageOverlay(context: GameContext) {
    guard let gameScene = context.scene as? GameScene else { return }

    // Get current recipe for display
    let currentRecipe = getCurrentRecipe(context: context)

    nextStageOverlay = NextStageOverlay(recipe: currentRecipe, size: gameScene.size)
    nextStageOverlay?.delegate = self
    gameScene.addChild(nextStageOverlay!)
    nextStageOverlay?.show()

    // Pause ingredient spawning
    pauseGameplay(context: context)
  }

  private func showGameOverOverlay(context: GameContext) {
    guard let gameScene = context.scene as? GameScene else { return }

    gameOverOverlay = GameOverOverlay(size: gameScene.size)
    gameOverOverlay?.delegate = self
    gameScene.addChild(gameOverOverlay!)
    gameOverOverlay?.show()

    // Update overlay with current scores
    updateGameOverOverlayScores(context: context)

    // Pause gameplay
    pauseGameplay(context: context)
  }

  private func getCurrentRecipe(context: GameContext) -> Recipe {
    if let recipeEntity = context.entityManager.getEntitiesWith(componentType: CurrentRecipeComponent.self).first,
       let recipeComponent = recipeEntity.component(ofType: CurrentRecipeComponent.self)
    {
      return recipeComponent.currentRecipe
    }
    return GameData.recipes[0] // Fallback
  }

  private func updateGameOverOverlayScores(context _: GameContext) {
    // The overlay will get the scores from GameState when it shows
    // We could also pass them directly if needed
  }

  private func pauseGameplay(context: GameContext) {
    // Disable crab interaction
    if let crabEntity = context.entityManager.getEntitiesWith(componentType: InteractionComponent.self)
      .first(where: { entity in
        entity.component(ofType: SpriteComponent.self)?.node is CrabNode
      }),
      let interaction = crabEntity.component(ofType: InteractionComponent.self)
    {
      interaction.isEnabled = false
    }
  }

  private func resumeGameplay(context: GameContext) {
    // Re-enable crab interaction
    if let crabEntity = context.entityManager.getEntitiesWith(componentType: InteractionComponent.self)
      .first(where: { entity in
        entity.component(ofType: SpriteComponent.self)?.node is CrabNode
      }),
      let interaction = crabEntity.component(ofType: InteractionComponent.self)
    {
      interaction.isEnabled = true
    }

    // Reset heart
  }

  func hideNextStageOverlay(context: GameContext) {
    nextStageOverlay?.removeFromParent()
    nextStageOverlay = nil
    context.gameState.nextLevel()
    resumeGameplay(context: context)
  }

  // MARK: - NextStageOverlayDelegate

  func didTapNextStage() {
    guard let context else { return }
    hideNextStageOverlay(context: context)
  }

  // MARK: - GameOverOverlayDelegate

  func didTapPlayAgain() {
    guard let context else { return }

    // Hide overlay
    gameOverOverlay?.hide()
    gameOverOverlay?.removeFromParent()
    gameOverOverlay = nil

    // Reset game state
    context.gameState.resetGameState()

    // Reset all components
    resetGameComponents(context: context)

    // Resume gameplay
    resumeGameplay(context: context)
  }

  func didTapBackHome() {
    guard let context else { return }

    // Navigate to home scene
    SoundManager.sound.playLobbyMusic()
    context.sceneCoordinator.transitionWithAnimation(to: .home)
  }

  private func resetGameComponents(context: GameContext) {
    // Reset life component
    if let lifeEntity = context.entityManager.getEntitiesWith(componentType: LifeComponent.self).first,
       let lifeComponent = lifeEntity.component(ofType: LifeComponent.self),
       let spriteComponent = lifeEntity.component(ofType: SpriteComponent.self),
       let lifeNode = spriteComponent.node as? LifeDisplayNode
    {
      lifeComponent.resetLives()
      lifeNode.updateHeartDisplay(lifeComponent.currentLives)
    }

    // Reset score component
    if let scoreEntity = context.entityManager.getEntitiesWith(componentType: ScoreComponent.self).first,
       let scoreComponent = scoreEntity.component(ofType: ScoreComponent.self),
       let spriteComponent = scoreEntity.component(ofType: SpriteComponent.self),
       let scoreNode = spriteComponent.node as? ScoreDisplayNode
    {
      scoreComponent.resetScore()
      scoreNode.updateScore(scoreComponent.score)
    }

    // Reset recipe component to first recipe
    if let recipeEntity = context.entityManager.getEntitiesWith(componentType: CurrentRecipeComponent.self).first,
       let recipeComponent = recipeEntity.component(ofType: CurrentRecipeComponent.self),
       let spriteComponent = recipeEntity.component(ofType: SpriteComponent.self),
       let recipeCardNode = spriteComponent.node as? RecipeCardNode
    {
      let firstRecipe = GameData.recipes[0]
      recipeComponent.updateRecipe(firstRecipe)
      recipeCardNode.updateRecipe(firstRecipe)
    }

    // Remove all ingredients from screen
    let ingredientEntities = context.entityManager.getEntitiesWith(componentType: IngredientComponent.self)
    for entity in ingredientEntities {
      if let lifecycleComponent = entity.component(ofType: LifecycleComponent.self) {
        lifecycleComponent.markForRemoval()
      }
    }
  }
}
