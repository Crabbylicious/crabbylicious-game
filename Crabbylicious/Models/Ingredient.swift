//
//  Ingredient.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation

struct Ingredient: Identifiable, Hashable {
  let id = UUID()
  let imageName: String
  let name: String
  let isAbsurd: Bool
  let scale: CGFloat
}
