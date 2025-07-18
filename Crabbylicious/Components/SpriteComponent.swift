//
//  SpriteComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
  let node: SKSpriteNode

  init(node: SKSpriteNode) {
    self.node = node
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
