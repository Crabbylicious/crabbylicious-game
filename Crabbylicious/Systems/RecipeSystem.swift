////
////  RecipeSystem.swift
////  Crabbylicious
////
////  Created by Nadaa Shafa Nadhifa on 22/07/25.
////
//
//import GameplayKit
//import SpriteKit
//
//class RecipeSystem: GKComponentSystem<IngredientComponent> {
//  weak var recipeCardNode: RecipeCardNode?
//  private var currentRecipe: Recipe?
//  private var collectedIngredients: [String: Int] = [:]
//  private var recipesCompleted: Int = 0
//  
//  init(recipeCardNode: RecipeCardNode) {
//    self.recipeCardNode = recipeCardNode
//    super.init(componentClass: IngredientComponent.self)
//  }
//  
//  func startNewRecipe(_ recipe: Recipe) {
//    currentRecipe = recipe
//    collectedIngredients.removeAll()
//    updateRecipeCard()
//  }
//  
//  func collectIngredient(_ ingredient: Ingredient) {
//    guard let recipe = currentRecipe else { return }
//    
//    // Check if this ingredient is needed for current recipe
//    if let requiredAmount = recipe.ingredients[ingredient.name],
//       let currentAmount = collectedIngredients[ingredient.name] {
//      
//      // Only collect if we still need more of this ingredient
//      if currentAmount < requiredAmount {
//        collectedIngredients[ingredient.name] = currentAmount + 1
//        updateRecipeCard()
//        
//        // Check if recipe is complete
//        if isRecipeComplete() {
//          completeRecipe()
//        }
//      }
//    } else if recipe.ingredients[ingredient.name] != nil {
//      // First time collecting this ingredient for current recipe
//      collectedIngredients[ingredient.name] = 1
//      updateRecipeCard()
//      
//      if isRecipeComplete() {
//        completeRecipe()
//      }
//    }
//  }
//  
//  private func isRecipeComplete() -> Bool {
//    guard let recipe = currentRecipe else { return false }
//    
//    for (ingredientName, requiredAmount) in recipe.ingredients {
//      let collectedAmount = collectedIngredients[ingredientName] ?? 0
//      if collectedAmount < requiredAmount {
//        return false
//      }
//    }
//    return true
//  }
//  
//  private func completeRecipe() {
//    recipesCompleted += 1
//    // You can add completion effects, sounds, etc. here
//    
//    // Start next recipe or show completion
//    // For now, let's just reset for the same recipe
//    collectedIngredients.removeAll()
//    updateRecipeCard()
//  }
//  
//  private func updateRecipeCard() {
//    guard let recipe = currentRecipe,
//          let cardNode = recipeCardNode else { return }
//    
//    // Calculate remaining recipes needed
//    let remainingCount = max(0, 10 - recipesCompleted) // Assuming goal of 10 recipes
//    
//    // Create ingredient display array
//    var ingredientDisplay: [(imageName: String, collected: Int, required: Int)] = []
//    
//    for (ingredientName, requiredAmount) in recipe.ingredients {
//      let collectedAmount = collectedIngredients[ingredientName] ?? 0
//      let imageName = getImageName(for: ingredientName)
//      ingredientDisplay.append((imageName: imageName, collected: collectedAmount, required: requiredAmount))
//    }
//    
//    // Let the node handle only the visual display
//    cardNode.displayRecipeData(
//      remainingCount: remainingCount,
//      ingredients: ingredientDisplay
//    )
//  }
//  
//  private func getImageName(for ingredientName: String) -> String {
//    // Map ingredient names to your actual image file names
//    switch ingredientName.lowercased() {
//    case "bread":
//      return "bread_icon" // or whatever your actual image name is
//    case "cheese":
//      return "cheese_icon"
//    case "egg":
//      return "egg_icon"
//    case "tomato":
//      return "tomato_icon"
//    case "lettuce":
//      return "lettuce_icon"
//    default:
//      return ingredientName // fallback to ingredient name
//    }
//  }
//  
//  // Call this from your collision detection or ingredient collection logic
//  func handleIngredientCollection(entity: IngredientEntity) {
//    collectIngredient(entity.ingredient)
//    
//    // Remove the entity from the scene
//    if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
//      spriteComponent.node.removeFromParent()
//    }
//    
//    // Remove entity from component system
//    if let ingredientComponent = entity.component(ofType: IngredientComponent.self) {
//      removeComponent(foundIn: entity)
//    }
//  }
//  
//  func getCurrentRecipe() -> Recipe? {
//    return currentRecipe
//  }
//  
//  func getCollectedIngredients() -> [String: Int] {
//    return collectedIngredients
//  }
//  
//  func getRecipesCompleted() -> Int {
//    return recipesCompleted
//  }
//}
