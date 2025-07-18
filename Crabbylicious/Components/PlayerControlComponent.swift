//
//  PlayerControlComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import Foundation
import GameplayKit

class PlayerControlComponent: GKComponent {
  var isControllable: Bool = true
  var gameArea: CGRect

  init(gameArea: CGRect) {
    self.gameArea = gameArea
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
