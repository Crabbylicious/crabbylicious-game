//
//  InteractionComponent.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import GameplayKit

class InteractionComponent: GKComponent {
  enum InteractionType {
    case button
    case draggable
  }

  let interactionType: InteractionType
  var isEnabled: Bool = true

  var onTap: (() -> Void)? // For buttons
  var onDrag: ((CGPoint) -> Void)? // For draggable items

  private var isDragging: Bool = false

  // MARK: - INITIALIZATION

  init(type: InteractionType) {
    interactionType = type
    super.init()
  }

  /// @escaping - inform callers of a function that takes a closure that the closure might be stored or otherwise
  /// outlive the scope of the receiving function.
  static func button(onTap: @escaping () -> Void) -> InteractionComponent {
    let interaction = InteractionComponent(type: .button)
    interaction.onTap = onTap
    return interaction
  }

  static func draggable(onDrag: @escaping (CGPoint) -> Void) -> InteractionComponent {
    let interaction = InteractionComponent(type: .draggable)
    interaction.onDrag = onDrag
    return interaction
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Touch Handling

  func handleTouchBegan(at _: CGPoint) {
    guard isEnabled else { return }

    switch interactionType {
    case .button:
      // ...
      break
    case .draggable:
      isDragging = true
    }
  }

  func handleTouchMoved(to location: CGPoint) {
    guard isEnabled else { return }

    switch interactionType {
    case .button:
      // No movement handling for buttons
      break
    case .draggable:
      if isDragging {
        onDrag?(location)
      }
    }
  }

  func handleTouchEnded(at _: CGPoint) {
    guard isEnabled else { return }

    switch interactionType {
    case .button:
      onTap?()

    case .draggable:
      isDragging = false
    }
  }

  func handleTouchCancelled() {
    isDragging = false

    switch interactionType {
    case .button:
      // ...
      break
    case .draggable:
      // ...
      break
    }
  }

  func enable() {
    isEnabled = true

    // reference to its parents entity, end edit another components
    if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {
      spriteComponent.alpha = 1.0
    }
  }

  func disable() {
    isEnabled = false
    isDragging = false

    // reference to its parents entity, end edit another components
    if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {
      spriteComponent.alpha = 0.5
    }
  }
}
