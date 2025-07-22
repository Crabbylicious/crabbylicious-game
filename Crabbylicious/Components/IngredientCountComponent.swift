class IngredientCountComponent: GKComponent {
  let ingredient: Ingredient
  var count: Int
  var maxCount: Int
  
  init(ingredient: Ingredient, count: Int, maxCount: Int) {
    self.ingredient = ingredient
    self.count = count
    self.maxCount = maxCount
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}