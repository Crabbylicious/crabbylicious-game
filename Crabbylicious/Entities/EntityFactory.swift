//
//  EntityFactory.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import GameplayKit

class EntityFactory {
  // MARK: - Crab Entity

  static func createCrab(position: CGPoint, gameArea: CGRect) -> GKEntity {
    let entity = GKEntity()

    // Create crab node (using your existing CrabNode)
    let crabNode = CrabNode(size: CGSize(width: 100, height: 100))
    crabNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: crabNode, layer: .gameplay))

    // Setup physics for collision detection
    if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
      spriteComponent.setupPhysics(
        bodyType: .rectangle(size: CGSize(width: crabNode.size.width * 0.7, height: crabNode.size.height * 0.4)),
        categoryBitMask: PhysicsCategory.player,
        contactTestBitMask: PhysicsCategory.ingredient,
        collisionBitMask: 0,
        isDynamic: false,
        affectedByGravity: false
      )
    }

    // Add drag interaction for player control
    let dragInteraction = InteractionComponent.draggable { newPosition in
      // Handle crab dragging - constrain to game area
      let constrainedX = max(gameArea.minX + 50, min(gameArea.maxX - 50, newPosition.x))
      entity.component(ofType: SpriteComponent.self)?.position.x = constrainedX
    }
    entity.addComponent(dragInteraction)

    return entity
  }

  // MARK: - Ingredient Entity

  static func createIngredient(ingredient: Ingredient, position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    // Create ingredient node (using your existing IngredientNode)
    let ingredientNode = IngredientNode(ingredient: ingredient)
    ingredientNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: ingredientNode, layer: .gameplay))
    entity.addComponent(IngredientComponent(ingredient: ingredient))
    entity.addComponent(LifecycleComponent())

    // Setup physics
    if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
      spriteComponent.setupPhysics(
        bodyType: .circle(radius: 40),
        categoryBitMask: PhysicsCategory.ingredient,
        contactTestBitMask: PhysicsCategory.player,
        collisionBitMask: 0,
        isDynamic: true,
        affectedByGravity: true
      )

      // Add some random horizontal velocity
      let randomXVelocity = CGFloat.random(in: -10 ... 10)
      spriteComponent.physicsBody?.velocity = CGVector(dx: randomXVelocity, dy: 0)
    }

    return entity
  }

  // MARK: - Button Entity

  static func createButton(
    nodeType: ButtonNodeType,
    position: CGPoint,
    onTap: @escaping () -> Void
  ) -> GKEntity {
    let entity = GKEntity()

    // Create button node based on type
    let buttonNode = createButtonNode(type: nodeType)
    buttonNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: buttonNode, layer: .ui))

    // Add tap interaction
    let tapInteraction = InteractionComponent.button(onTap: onTap)
    entity.addComponent(tapInteraction)

    return entity
  }

  // MARK: - Recipe Card Entity

  static func createRecipeCard(position: CGPoint, size: CGSize) -> GKEntity {
    let entity = GKEntity()

    // Create recipe card node (using your existing RecipeCardNode)
    let recipeCardNode = RecipeCardNode(size: size)
    recipeCardNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: recipeCardNode, layer: .ui))
    entity.addComponent(CurrentRecipeComponent(recipe: GameData.recipes[0]))

    return entity
  }

  // MARK: - Score Entity

  static func createScoreDisplay(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    // Create score display node (using your existing ScoreDisplayNode)
    let scoreDisplayNode = ScoreDisplayNode()
    scoreDisplayNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: scoreDisplayNode, layer: .ui))
    entity.addComponent(ScoreComponent())

    return entity
  }

  // MARK: - Life Display Entity

  static func createLifeDisplay(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    // Create life display node (using your existing LifeDisplayNode)
    let lifeDisplayNode = LifeDisplayNode()
    lifeDisplayNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: lifeDisplayNode, layer: .ui))
    entity.addComponent(LifeComponent())

    return entity
  }

  // MARK: - Bubble Background Entity

  static func createBubbleBackground(size: CGSize, position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    // Create bubble background node
    let bubbleNode = BubbleBackgroundNode(size: size)
    bubbleNode.position = position

    // Add components
    entity.addComponent(SpriteComponent(node: bubbleNode, layer: .background))

    return entity
  }

  // MARK: - Helper Methods

  private static func createButtonNode(type: ButtonNodeType) -> SKSpriteNode {
    switch type {
    case .play:
      ButtonNode(imageName: "buttonPlay")
    case .pause:
      ButtonNode(imageName: "ButtonPause", scale: 0.08)
    case .resume:
      ButtonNode(imageName: "ButtonResume", scale: 0.3)
    case .backHome:
      ButtonNode(imageName: "ButtonBackHome", scale: 0.3)
    case .playAgain:
      ButtonNode(imageName: "ButtonPlayAgain", scale: 0.25)
    case .nextStage:
      ButtonNode(imageName: "ButtonNextStage", scale: 0.25)
    case .yes:
      ButtonNode(imageName: "ButtonYes", scale: 0.2)
    case .no:
      ButtonNode(imageName: "ButtonNo", scale: 0.2)
    }
  }
}
