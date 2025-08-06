//
//  BubbleBackgroundSystem.swift
//  Crabbylicious
//
//  Created by Nessa on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class BubbleBackgroundSystem {
  func update(deltaTime: TimeInterval, entityManager: EntityManager, sceneSize: CGSize) {
    let entities = entityManager.getEntitiesWith(componentType: BubbleBackgroundComponent.self)
    for entity in entities {
      guard let bubbleComponent = entity.component(ofType: BubbleBackgroundComponent.self) else { continue }

      bubbleComponent.elapsedTime += deltaTime
      let amplitude = bubbleComponent.amplitudeX
      let freq = bubbleComponent.frequency
      let speedY = bubbleComponent.speedY
      let overlapY = bubbleComponent.overlapY
      let elapsed = bubbleComponent.elapsedTime
      let nodes = bubbleComponent.nodes
      guard nodes.count == 2 else { continue }

      for (_, node) in nodes.enumerated() {
        // Goyang kiri-kanan
        let offsetX = amplitude * sin(2 * .pi * freq * elapsed)

        // Naik ke atas
        node.position.x = sceneSize.width / 2 + offsetX
        node.position.y += CGFloat(speedY * deltaTime)
      }

      // Cek dan reset jika ada node yang keluar dari atas layar
      for i in 0 ..< 2 {
        let node = nodes[i]
        let otherNode = nodes[1 - i]
        if node.position.y - node.size.height / 2 >= sceneSize.height {
          node.position.y = otherNode.position.y - otherNode.size.height + overlapY // overlap
        }
      }
    }
  }
}
