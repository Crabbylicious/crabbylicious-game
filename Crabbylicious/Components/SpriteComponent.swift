//
//  SpriteComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 18/07/25.
//

import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - CORE NODE

  let node: SKNode

  enum RenderLayer: CGFloat {
    case background = 08
    case gameplay = 10
    case ui = 20
  }

  var layer: RenderLayer {
    didSet {
      node.zPosition = layer.rawValue
    }
  }

  var physicsBody: SKPhysicsBody? {
    get { node.physicsBody }
    set { node.physicsBody = newValue }
  }

  var position: CGPoint {
    get { node.position }
    set { node.position = newValue }
  }

  var rotation: CGFloat {
    get { node.zRotation }
    set { node.zRotation = newValue }
  }

  var scale: CGFloat {
    get { node.xScale } // Assumming uniform scaling
    set { node.setScale(newValue) }
  }

  var alpha: CGFloat {
    get { node.alpha }
    set { node.alpha = newValue }
  }

  var isHidden: Bool {
    get { node.isHidden }
    set { node.isHidden = newValue }
  }

  var name: String? {
    get { node.name }
    set { node.name = newValue }
  }

  // MARK: - INITIALIZATION

  init(node: SKNode, layer: RenderLayer = .gameplay) {
    self.node = node
    self.layer = layer
    super.init()
  }

  static func createSprite(imageNamed: String) -> SpriteComponent {
    let sprite = SKSpriteNode(imageNamed: imageNamed)
    return SpriteComponent(node: sprite)
  }

  static func createLabel(
    text: String,
    fontSize: CGFloat = 20,
    fontName: String = "Arial",
    color: UIColor = .white,
    layer: RenderLayer = .ui
  ) -> SpriteComponent {
    let label = SKLabelNode(text: text)
    label.fontName = fontName
    label.fontSize = fontSize
    label.fontColor = color
    return SpriteComponent(node: label, layer: layer)
  }

  // MARK: - PHYSICS

  func setupPhysics(
    bodyType: PhysicsBodyType,
    categoryBitMask: UInt32 = 0,
    contactTestBitMask: UInt32 = 0,
    collisionBitMask: UInt32 = 0,
    isDynamic: Bool = true,
    affectedByGravity: Bool = true
  ) {
    let physicsBody = switch bodyType {
    case let .circle(radius):
      SKPhysicsBody(circleOfRadius: radius)
    case let .rectangle(size):
      SKPhysicsBody(rectangleOf: size)
    case let .texture(texture, size):
      SKPhysicsBody(texture: texture, size: size)
    }

    physicsBody.categoryBitMask = categoryBitMask
    physicsBody.contactTestBitMask = contactTestBitMask
    physicsBody.collisionBitMask = collisionBitMask
    physicsBody.isDynamic = isDynamic
    physicsBody.affectedByGravity = affectedByGravity

    self.physicsBody = physicsBody
  }

  // MARK: - ANIMATIONS MANAGEMENT

  private var animations: [String: SKAction] = [:]

  func preloadAnimation(name: String, action: SKAction) {
    animations[name] = action
  }

  func playAnimation(name: String, completion: (() -> Void)? = nil) {
    guard let action = animations[name] else {
      print("⚠️ Animation '\(name)' not found")
      return
    }

    node.run(action, completion: completion ?? {})
  }

  func playAnimation(_ action: SKAction, withKey key: String? = nil, completion: (() -> Void)? = nil) {
    if let key {
      node.run(action, withKey: key)
    } else {
      node.run(action, completion: completion ?? {})
    }
  }

  func stopAnimation(withKey key: String) {
    node.removeAction(forKey: key)
  }

  func stopAllAnimations() {
    node.removeAllActions()
  }

  func pauseAnimations() {
    node.isPaused = true
  }

  func resumeAnimations() {
    node.isPaused = false
  }

  // MARK: - TEXTURE MANAGEMENT

  private var textures: [String: SKTexture] = [:]

  func preloadTexture(name: String, texture: SKTexture) {
    textures[name] = texture
  }

  func setTexture(name: String) {
    guard let texture = textures[name],
          let sprite = node as? SKSpriteNode
    else {
      print("⚠️ Texture '\(name)' not found or node is not SKSpriteNode")
      return
    }
    sprite.texture = texture
  }

  func animateTextures(
    textureNames: [String],
    timePerFrame: TimeInterval,
    repeatCount: Int = 1
  ) {
    let textureArray = textureNames.compactMap { textures[$0] }
    guard !textureArray.isEmpty,
          let sprite = node as? SKSpriteNode else { return }

    let animation = SKAction.animate(
      with: textureArray,
      timePerFrame: timePerFrame
    )

    let repeatAction = repeatCount > 1 ?
      SKAction.repeat(animation, count: repeatCount) : animation

    sprite.run(repeatAction)
  }

  // MARK: - UTILS

  func addToScene(_ scene: SKScene) {
    scene.addChild(node)
  }

  func removeFromParent() {
    node.removeFromParent()
  }

  func isVisible() -> Bool {
    node.parent != nil
  }
}
