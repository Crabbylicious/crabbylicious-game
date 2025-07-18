//
//  CrabNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class CrabNode: SKSpriteNode {
    private let legsNode: SKSpriteNode
    private var legAnimationActionKey = "legAnimation"
    private var legTextures: [SKTexture] = []

    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "crabAndBowl")
        let atlas = SKTextureAtlas(named: "Legs")
        legTextures = [
            atlas.textureNamed("leg1"),
            atlas.textureNamed("leg2")
        ]
        legsNode = SKSpriteNode(texture: legTextures[0])
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.setScale(0.2)
        self.zPosition = 2
        
        // posisi dan ukuran legs crab
        legsNode.setScale(0.6)
        legsNode.position = CGPoint(x: 0, y: -self.size.height * 1.9) 
        legsNode.zPosition = 3
        addChild(legsNode)
    }

    func startLegAnimation() {
        guard legsNode.action(forKey: legAnimationActionKey) == nil else { return }
        let animation = SKAction.repeatForever(SKAction.animate(with: legTextures, timePerFrame: 0.15))
        legsNode.run(animation, withKey: legAnimationActionKey)
    }

    func stopLegAnimation() {
        legsNode.removeAction(forKey: legAnimationActionKey)
        legsNode.texture = legTextures[0] // reset posisi legs
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
