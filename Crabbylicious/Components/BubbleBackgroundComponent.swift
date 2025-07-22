//
//  BubbleBackgroundComponent.swift
//  Crabbylicious
//
//  Created by Nessa on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class BubbleBackgroundComponent: GKComponent {
  let speedY: CGFloat = 50.0 // kecepatan naik
  let amplitudeX: CGFloat = 5.0 // goyang kiri-kanan
  let frequency: CGFloat = 1.0 // frekuensi goyangan (Hz)
  let overlapY: CGFloat = 20.0 // overlap antar node, transisi halus
  var nodes: [BubbleBackgroundNode]
  var elapsedTime: TimeInterval = 0

  init(nodes: [BubbleBackgroundNode]) {
    self.nodes = nodes
    super.init()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
