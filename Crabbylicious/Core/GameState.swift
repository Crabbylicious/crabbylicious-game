//
//  GameState.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import Foundation

class GameState: ObservableObject {
  static let shared = GameState()
  
  @Published var state: GameStateEnum = .playing
  @Published var currentScore: Int = 0
  @Published var highScore: Int = 0 // .. will read and update from userDefaults or any other persistent storage
  @Published var currentLevel: Int = 1
  @Published var currentRecipeIndex: Int = 0
  @Published var shouldShowNextStageOverlay: Bool = false
  @Published var shouldShowGameOverOverlay: Bool = false
  
  private init() {
    loadHighScore()
  }
  
  func updateScore(_ newScore: Int) {
    currentScore = newScore
    if newScore > highScore {
      highScore = newScore
      saveHighScore()
    }
  }
  
  func resetGameState() {
    currentScore = 0
    currentLevel = 1
    state = .playing
    shouldShowNextStageOverlay = false
    shouldShowGameOverOverlay = false
  }
  
  func nextLevel() {
    currentLevel += 1
    shouldShowNextStageOverlay = false
    state = .playing
  }
  
  func gameOver() {
    state = .gameOver
    shouldShowGameOverOverlay = true
  }
  
  func completeRecipe() {
    state = .nextStage
    shouldShowNextStageOverlay = true
  }
  
  private func loadHighScore() {
    highScore = UserDefaults.standard.integer(forKey: "HighScore")
  }
  
  private func saveHighScore() {
    UserDefaults.standard.set(highScore, forKey: "HighScore")
  }
}
