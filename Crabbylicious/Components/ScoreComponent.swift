//
//  ScoreComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import GameplayKit

class ScoreComponent: GKComponent {
  private var _score: Int = 0
  var hasChanged: Bool = false // Track if score has changed since last system update

  var score: Int {
    get { _score }
    set {
      _score = newValue
      hasChanged = true
    }
  }

  func addScore(_ points: Int) {
    _score += points
    hasChanged = true
  }

  func resetScore() {
    _score = 0
    hasChanged = true
  }
}
