//
//  LifeComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import GameplayKit

// MARK: - LifeComponent

class LifeComponent: GKComponent {
  private let maxLives: UInt8 = 3
  var hasChanged: Bool = false
  var currentLives: UInt8 = 3

  func loseLife() {
    if currentLives > 0 {
      currentLives -= 1
      hasChanged = true
    }
  }

  func resetLives() {
    currentLives = maxLives
  }

  func isGameOver() -> Bool {
    currentLives <= 0
  }
}
