//
//  System.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import Foundation

protocol System {
  func update(deltaTime: TimeInterval, context: GameContext)
}
