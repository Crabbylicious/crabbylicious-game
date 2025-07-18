//
//  FallingComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class FallingComponent: GKComponent {
  var fallSpeed: CGFloat
  var rotationSpeed: CGFloat

  init(fallSpeed: CGFloat = 150, rotationSpeed: CGFloat = 1.0) {
    self.fallSpeed = fallSpeed
    self.rotationSpeed = rotationSpeed
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
