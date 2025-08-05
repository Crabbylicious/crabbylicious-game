//
//  BaseScene.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 05/08/25.
//

import GameplayKit
import SpriteKit

protocol BaseScene: SKScene {
  var entityManager: EntityManager { get }
  var systemManager: SystemManager { get }

  func setupSystems()
  func setupEntities()
}
