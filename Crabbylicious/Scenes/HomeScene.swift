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

  override func didMove(to _: SKView) {
    let background = BackgroundNode(size: size)
    background.zPosition = 0
    addChild(background)

    let ground = GroundNode(size: size)
    ground.zPosition = 1
    addChild(ground)

    let title = TitleNode(size: CGSize(width: 300, height: 300))
    title.position = CGPoint(x: gameArea.midX, y: gameArea.midY)
    title.zPosition = 10
    addChild(title)

    let topCloud = CloudNode(position: CGPoint(
      x: gameArea.minX + 70 + (CloudNode.cloudSize.width / 2),
      y: gameArea.maxY - 55 - (CloudNode.cloudSize.height / 2)
    ))
    topCloud.zPosition = 5
    addChild(topCloud)

    let bottomCloud = CloudNode(position: CGPoint(
      x: gameArea.maxX - 70 - (CloudNode.cloudSize.width / 2),
      y: gameArea.maxY - 151 - (CloudNode.cloudSize.height / 2)
    ))
    bottomCloud.zPosition = 5
    addChild(bottomCloud)
    
    let playButton = ButtonNode(imageName: "buttonPlay", size: size)
    playButton.position = CGPoint(x: gameArea.midX, y: gameArea.midY)
    playButton.zPosition = 10
    addChild(playButton)
    
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = self.nodes(at: location)
    
    for node in nodes {
      if let buttonNode = node as? ButtonNode {
        buttonNode.handleButtonPressed(button: buttonNode)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodes = self.nodes(at: location)
    
    for node in nodes {
      if let buttonNode = node as? ButtonNode {
        buttonNode.handleButtonReleased(button: buttonNode)
      }
    }
  }
}
