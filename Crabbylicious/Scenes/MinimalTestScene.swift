//
//  MinimalTestScene.swift
//  Crabbylicious
//
//  Test scene to isolate the crash
//

import SpriteKit

class MinimalTestScene: SKScene {
  override func didMove(to _: SKView) {
    print("MinimalTestScene loaded successfully")

    // Test basic sprite creation
    let testSprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
    testSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(testSprite)

    // Test if your background works
    do {
      let background = BackgroundNode(size: size)
      addChild(background)
      print("Background loaded successfully")
    } catch {
      print("Background failed: \(error)")
    }

    // Test recipe creation (this might be where the crash happens)
    do {
      print("Testing GameData...")
      let recipes = GameData.recipes
      print("Recipes loaded: \(recipes.count)")

      let ingredients = GameData.allIngredients
      print("Ingredients loaded: \(ingredients.count)")

      for ingredient in ingredients {
        print("Ingredient: \(ingredient.name) - Image: \(ingredient.imageName)")
      }
    } catch {
      print("GameData error: \(error)")
    }
  }
}
