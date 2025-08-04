//
//  LabelNode.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import SpriteKit

class GameLabelNode: SKLabelNode {
  private var shadowLabel: SKLabelNode?

  // MARK: - Initializers

  convenience init(text: String,
                   size: GameFontSize = .medium,
                   color: GameFontColor = .primary,
                   alignment: SKLabelHorizontalAlignmentMode = .center,
                   withShadow: Bool = false)
  {
    self.init()
    setupLabel(text: text, size: size, color: color, alignment: alignment, withShadow: withShadow)
  }

  override init() {
    super.init()
    setupDefaultFont()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupDefaultFont()
  }

  // MARK: - Setup Methods

  private func setupDefaultFont() {
    fontName = "PressStart2P"
    fontSize = GameFontSize.medium.points
    fontColor = GameFontColor.primary.color
    horizontalAlignmentMode = .center
    verticalAlignmentMode = .center
  }

  private func setupLabel(text: String,
                          size: GameFontSize,
                          color: GameFontColor,
                          alignment: SKLabelHorizontalAlignmentMode,
                          withShadow: Bool)
  {
    self.text = text
    fontSize = size.points
    fontColor = color.color
    horizontalAlignmentMode = alignment
    verticalAlignmentMode = .center

    if withShadow {
      addShadow()
    }
  }

  // MARK: - Shadow Methods

  private func addShadow(offset: CGPoint = CGPoint(x: 2, y: -2), alpha: CGFloat = 0.7) {
    guard shadowLabel == nil else { return }

    shadowLabel = SKLabelNode(fontNamed: "PressStart2P")
    shadowLabel?.text = text
    shadowLabel?.fontSize = fontSize
    shadowLabel?.fontColor = .black
    shadowLabel?.horizontalAlignmentMode = horizontalAlignmentMode
    shadowLabel?.verticalAlignmentMode = verticalAlignmentMode
    shadowLabel?.position = offset
    shadowLabel?.alpha = alpha
    shadowLabel?.zPosition = zPosition - 1

    parent?.insertChild(shadowLabel!, at: 0)
  }

  // MARK: - Utility Methods

  func updateText(_ newText: String) {
    text = newText
    shadowLabel?.text = newText
  }

  func updateColor(_ newColor: GameFontColor) {
    fontColor = newColor.color
  }

  func updateSize(_ newSize: GameFontSize) {
    fontSize = newSize.points
    shadowLabel?.fontSize = newSize.points
  }
}
