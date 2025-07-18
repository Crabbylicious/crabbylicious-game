//
//  LifetimeComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class LifetimeComponent: GKComponent {
  var timeRemaining: TimeInterval

  init(lifetime: TimeInterval) {
    timeRemaining = lifetime
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
