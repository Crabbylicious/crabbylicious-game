//
//  BackgroundNode.swift
//  Crabbylicious
//
//  Created by Nessa on 16/07/25.
//

import SpriteKit
import GameplayKit

class BackgroundNode: SKSpriteNode {
    
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "background")
        super.init(texture: texture, color: .clear, size: size)
        self.position = CGPoint(x: size.width / 2, y: size.height / 2)
        self.zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
