//
//  GameContext.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import SpriteKit

struct GameContext {
  let scene: SKScene
  let entityManager: EntityManager
  let sceneCoordinator: SceneCoordinator
  let gameState: GameState
  
  init(scene: SKScene, entityManager: EntityManager, sceneCoordinator: SceneCoordinator, gameState: GameState = GameState.shared) {
    self.scene = scene
    self.entityManager = entityManager
    self.sceneCoordinator = sceneCoordinator
    self.gameState = gameState
  }
}
