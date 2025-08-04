//
//  ScoreComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import GameplayKit

class ScoreComponent: GKComponent {
  var score: Int = 0 {
    didSet {
      hasChanged = true
      lastAddedPoints = score - oldValue
    }
  }

  var hasChanged: Bool = false
  var lastAddedPoints: Int = 0

  func addPoints(_ points: Int) {
    score += points
  }

  func resetScore() {
    score = 0
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
