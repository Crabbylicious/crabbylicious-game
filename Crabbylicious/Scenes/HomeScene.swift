//
//  HomeScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 06/08/25.
//

import Foundation
import SpriteKit

class HomeScene: SKScene, BaseScene {
  let entityManager: EntityManager = .init()

  override func didMove(to view: SKView) {
    SceneCoordinator.shared.setView(view)

    setupEntities()

    AnimationManager.shared.animateSceneEntrance(for: self)
  }

  func setupEntities() {
    // 1. Background entity
    let backgroundEntity = EntityFactory.createBackground(size: size)
    entityManager.addEntity(backgroundEntity)
    if let spriteComponent = backgroundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 2. Ground entity
    let groundEntity = EntityFactory.createGround(
      position: CGPoint(x: size.width / 2, y: 40)
    )
    entityManager.addEntity(groundEntity)
    if let spriteComponent = groundEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 3. Title entity
    let titleEntity = EntityFactory.createTitle(
      position: CGPoint(x: size.width / 2, y: size.height / 2 + 100)
    )
    entityManager.addEntity(titleEntity)
    if let spriteComponent = titleEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 4. Cloud entity
    let cloudEntity1 = EntityFactory.createCloud(
      position: CGPoint(x: size.width / 2 - 80, y: size.height / 2 + 200),
      name: "cloud1"
    )
    entityManager.addEntity(cloudEntity1)
    if let spriteComponent = cloudEntity1.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    let cloudEntity2 = EntityFactory.createCloud(
      position: CGPoint(x: size.width / 2 + 90, y: size.height / 2 + 300),
      name: "cloud2"
    )
    entityManager.addEntity(cloudEntity2)
    if let spriteComponent = cloudEntity2.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 5. Play Button
    let playButtonEntity = EntityFactory.createButton(
      buttonNodeType: .play,
      position: CGPoint(x: 200, y: 300),
      onTap: {
        // ..
      }
    )
    entityManager.addEntity(playButtonEntity)
    if let spriteComponent = playButtonEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }

    // 6. Current High Score
    let currentHighScoreEntity = EntityFactory.createCurrentHighScore(
      position: CGPoint(x: size.width / 2, y: size.height / 2)
    )
    entityManager.addEntity(currentHighScoreEntity)
    if let spriteComponent = currentHighScoreEntity.component(ofType: SpriteComponent.self) {
      spriteComponent.addToScene(self)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let touchedNode = atPoint(location)

    if touchedNode.name == "playButton" {
      // not moving yet,
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let touchedNode = atPoint(location)

    if touchedNode.name == "playButton" {
      SceneCoordinator.shared.transitionWithAnimation(to: .game)
    }
  }
}
