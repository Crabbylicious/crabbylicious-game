//
//  LifecycleComponent.swift
//  FruitCatcher
//
//  Created by Java Kanaya Prada on 27/07/25.
//

import GameplayKit

class LifecycleComponent: GKComponent {
  enum State {
    case created
    case active
    case markedForRemoval
  }

  var state: State = .created

  func markForRemoval() {
    state = .markedForRemoval
  }
}
