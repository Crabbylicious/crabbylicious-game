//
//  PhysicsBodyType.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import SpriteKit

enum PhysicsBodyType {
  case circle(radius: CGFloat)
  case rectangle(size: CGSize)
  case texture(texture: SKTexture, size: CGSize)
}
