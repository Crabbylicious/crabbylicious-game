//
//  Recipe.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation

struct Recipe: Identifiable {
  let id = UUID()
  let name: String
  let ingredients: [Ingredient: Int]
}
