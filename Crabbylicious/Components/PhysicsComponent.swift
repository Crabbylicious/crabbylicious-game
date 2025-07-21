//
//  PhysicsComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class PhysicsComponent: GKComponent {
  let physicsBody: SKPhysicsBody

  init(physicsBody: SKPhysicsBody) {
    self.physicsBody = physicsBody
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
