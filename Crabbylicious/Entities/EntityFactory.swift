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

    let crabNode = CrabNode(size: CGSize(width: 100, height: 100))
    crabNode.position = position

    entity.addComponent(SpriteComponent(node: crabNode, layer: .gameplay))

    let dragInteraction = InteractionComponent.draggable { newPosition in
      let constrainedX = max(gameArea.minX + 50, min(gameArea.maxX - 50, newPosition.x))
      entity.component(ofType: SpriteComponent.self)?.position.x = constrainedX
    }

    entity.addComponent(dragInteraction)

    return entity
  }

  // MARK: - Ingredient Entity

  static func createIngredient(ingredient: Ingredient, position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let ingredientNode = IngredientNode(ingredient: ingredient)
    ingredientNode.position = position

    entity.addComponent(SpriteComponent(node: ingredientNode, layer: .gameplay))
    entity.addComponent(IngredientComponent(ingredient: ingredient))
    entity.addComponent(LifecycleComponent())

    return entity
  }

  // MARK: - Button Entity

  static func createButton(
    buttonNodeType: ButtonNodeType,
    position: CGPoint,
    onTap: @escaping () -> Void
  ) -> GKEntity {
    let entity = GKEntity()

    let buttonNode = createButtonNode(type: buttonNodeType)
    buttonNode.position = position

    entity.addComponent(SpriteComponent(node: buttonNode, layer: .ui))

    let tapInteraction = InteractionComponent.button(onTap: onTap)
    entity.addComponent(tapInteraction)

    return entity
  }

  // MARK: - Recipe Card Entity

  static func createRecipeCard(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let recipeCardNode = RecipeCardNode(recipe: GameData.recipes[0])
    recipeCardNode.position = position

    entity.addComponent(SpriteComponent(node: recipeCardNode, layer: .ui))
    entity.addComponent(CurrentRecipeComponent(recipe: GameData.recipes[0]))

    return entity
  }

  // MARK: - Score Entity

  static func createScoreDisplay(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let scoreDisplayNode = ScoreDisplayNode()
    scoreDisplayNode.position = position

    entity.addComponent(SpriteComponent(node: scoreDisplayNode, layer: .ui))
    entity.addComponent(ScoreComponent())

    return entity
  }

  // MARK: - Life Display Entity

  static func createLifeDisplay(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let lifeDisplayNode = LifeDisplayNode()
    lifeDisplayNode.position = position

    entity.addComponent(SpriteComponent(node: lifeDisplayNode, layer: .ui))
    entity.addComponent(LifeComponent())

    return entity
  }

  // MARK: - Background Entity

  static func createBubbleBackground(size: CGSize, position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let bubbleNode = BubbleBackgroundNode(size: size)
    bubbleNode.position = position

    entity.addComponent(SpriteComponent(node: bubbleNode, layer: .background))

    return entity
  }

  static func createBackground(size: CGSize) -> GKEntity {
    let entity = GKEntity()

    let backgroundNode = BackgroundNode(size: size)

    entity.addComponent(SpriteComponent(node: backgroundNode, layer: .background))

    return entity
  }

  static func createGround(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let groundNode = GroundNode(position: position)

    entity.addComponent(SpriteComponent(node: groundNode, layer: .background))

    return entity
  }

  static func createTitle(position: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let titleNode = TitleNode(position: position)

    entity.addComponent(SpriteComponent(node: titleNode, layer: .background))

    return entity
  }

  static func createCloud(position: CGPoint, name: String) -> GKEntity {
    let entity = GKEntity()

    let cloudNode = CloudNode(position: position, name: name)

    entity.addComponent(SpriteComponent(node: cloudNode, layer: .background))

    return entity
  }

  static func createCurrentHighScore(position _: CGPoint) -> GKEntity {
    let entity = GKEntity()

    let currentHighScoreLabelNode = GameLabelNode(text: "Current Highscore : xxx")

    entity.addComponent(SpriteComponent(node: currentHighScoreLabelNode, layer: .background))

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
