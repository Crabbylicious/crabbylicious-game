//
//  FallingComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class FallingComponent: GKComponent {
  var rotationSpeed: CGFloat
  var baseMass: CGFloat // For difficulty scaling

  init(rotationSpeed: CGFloat = 1.0, baseMass: CGFloat = 1.0) {
    self.rotationSpeed = rotationSpeed
    self.baseMass = baseMass
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
