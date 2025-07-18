//
//  FallingComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class FallingComponent: GKComponent {
  var velocity: CGFloat // Current falling velocity
  var gravity: CGFloat // Acceleration due to gravity
  var maxFallSpeed: CGFloat // Terminal velocity
  var rotationSpeed: CGFloat

  init(initialVelocity: CGFloat = 0, gravity: CGFloat = 400, maxFallSpeed: CGFloat = 600,
       rotationSpeed: CGFloat = 1.0)
  {
    velocity = initialVelocity
    self.gravity = gravity
    self.maxFallSpeed = maxFallSpeed
    self.rotationSpeed = rotationSpeed
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
