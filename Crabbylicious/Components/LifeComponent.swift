//
//  LifeComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import GameplayKit

// MARK: - LifeComponent

class LifeComponent: GKComponent {
  var lives: Int = 3 {
    didSet { hasChanged = true }
  }

  var maxLives: Int = 3
  var hasChanged: Bool = false

  func loseLife() {
    if lives > 0 {
      lives -= 1
    }
  }

  func resetLives() {
    lives = maxLives
  }

  func isGameOver() -> Bool {
    lives <= 0
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
