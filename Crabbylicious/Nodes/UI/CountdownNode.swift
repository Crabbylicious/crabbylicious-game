//
//  CountdownNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 19/07/25.
//

import Foundation
import SpriteKit

class CountdownNode: SKLabelNode {
  // MARK: - Initialization

  init(position: CGPoint) {
    super.init()

    // Setup label properties
    fontName = "Helvetica-Bold"
    text = "3"
    fontSize = 120
    fontColor = .white
    self.position = position
    zPosition = 15
    alpha = 0

    // Center the text
    horizontalAlignmentMode = .center
    verticalAlignmentMode = .center
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
