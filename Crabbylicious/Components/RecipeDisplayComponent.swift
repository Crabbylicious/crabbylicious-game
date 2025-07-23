//
//  RecipeDisplayComponent.swift
//  Crabbylicious
//
//  Created by Nadaa Shafa Nadhifa on 22/07/25.
//

import GameplayKit
import SwiftUI

class RecipeDisplayComponent: GKComponent {
  var needsUpdate: Bool = false

  override init() {
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
