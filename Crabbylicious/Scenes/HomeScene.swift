//
//  HomeScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit
import SpriteKit
import SwiftUI

class HomeScene: SKScene {
  let gameArea: CGRect
  
  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    super.init(size: size)
  }
  
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMove(to view: SKView) {
    let background = BackgroundNode(size: size)
    background.zPosition = 0
    addChild(background)
    
    let ground = GroundNode (size: size)
    ground.zPosition = 1
    addChild(ground)
    
    let title = TitleNode(size: CGSize(width: 300, height: 300))
    title.position = CGPoint(x: gameArea.midX, y: gameArea.midY)
    title.zPosition = 10
    addChild(title)
  }

  override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
    // TODO: Handle touch input
  }
}
