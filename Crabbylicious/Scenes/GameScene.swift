//
//  GameScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import GameplayKit

class GameScene: SKScene {
  let gameArea: CGRect
  let crab: CrabNode

  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let margin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

    crab = CrabNode(size: size)

    super.init(size: size)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // make every node visible
  override func didMove(to _: SKView) {
    let background = BackgroundNode(size: size)
    addChild(background)

    let ground = GroundNode(size: size)
    addChild(ground)

    crab.position = CGPoint(x: size.width / 2, y: size.height * 0.13)
    addChild(crab)
  }

  // crab movement
  override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
    for touch in touches {
      let pointOfTouch = touch.location(in: self) // where we touch the screen right now
      let previousPointOfTouch = touch.previousLocation(in: self) // where we were touching before

      let amountDragged = pointOfTouch.x - previousPointOfTouch.x

      crab.position.x += amountDragged

      let moreMarginBowl = crab.size.width / 1.1 //

      if crab.position.x > CGRectGetMaxX(gameArea) - moreMarginBowl {
        crab.position.x = CGRectGetMaxX(gameArea) - moreMarginBowl
      }

      if crab.position.x < CGRectGetMinX(gameArea) + moreMarginBowl {
        crab.position.x = CGRectGetMinX(gameArea) + moreMarginBowl
      }
    }
  }
}
