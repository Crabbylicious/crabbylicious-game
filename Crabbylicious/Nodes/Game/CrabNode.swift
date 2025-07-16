//
//  CrabNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation
import SpriteKit
import GameplayKit

class CrabNode: SKSpriteNode {
    
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "crabAndBowl2")
        super.init(texture: texture, color: .clear, size: size)
        self.setScale(0.15) // TODO: ganti biar ga penyet
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
