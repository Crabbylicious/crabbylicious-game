//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // make every node visible
    override func didMove(to view: SKView) {
        let background = BackgroundNode(size: self.size)
        self.addChild(background)
        
        let ground = GroundNode(size: self.size)
        self.addChild(ground)
    }
    
}
