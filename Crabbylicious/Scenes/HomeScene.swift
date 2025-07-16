//
//  HomeScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import SpriteKit

class HomeScene: SKScene {
    
    var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //super.didMove(to: view)
        print("didMove called ✅")
        setupScene()
        setupUI()
    }
    
    private func setupScene() {
        let background = SKSpriteNode(imageNamed: "background")
      background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 10
        background.size = self.size
        
        addChild(background)
        print("background spawned ✅")
    }
    
    private func setupUI() {
        // TODO: Setup home screen UI
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Handle touch input
    }
}
