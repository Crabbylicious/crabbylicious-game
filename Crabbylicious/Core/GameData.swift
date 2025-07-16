//
//  GameData.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation

class GameData {
  // Valid ingredients
  static let cabbage = Ingredient(imageName: "kubis", name: "kubis", isAbsurd: false)
  static let kacangPanjang = Ingredient(imageName: "kacang-panjang", name: "kacang panjang", isAbsurd: false)
  static let kacang = Ingredient(imageName: "kacang", name: "kacang", isAbsurd: false)
  static let krupuk = Ingredient(imageName: "krupuk", name: "krupuk", isAbsurd: false)
  static let lontong = Ingredient(imageName: "lontong", name: "lontong", isAbsurd: false)
  static let tahu = Ingredient(imageName: "tahu", name: "tahu", isAbsurd: false)
  static let telor = Ingredient(imageName: "telor", name: "telor", isAbsurd: false)

  // Absurd ingredients (traps)
  static let trapChili = Ingredient(imageName: "trap-chili", name: "trap chili", isAbsurd: true)
  static let trapFishBone = Ingredient(imageName: "trap-fish-bone", name: "trap fish bone", isAbsurd: true)

  static let recipes = [
    Recipe(name: "Gado-Gado", ingredients: [
      cabbage: 2,
      kacangPanjang: 2,
      kacang: 1,
      lontong: 2,
      tahu: 1
    ]),
    Recipe(name: "Ketoprak", ingredients: [
      lontong: 3,
      tahu: 2,
      kacang: 2,
      krupuk: 1
    ]),
    Recipe(name: "Nasi Gudeg", ingredients: [
      telor: 2,
      tahu: 1,
      krupuk: 2,
      cabbage: 1
    ])
  ]

  static let allIngredients = [
    // Valid ingredients
    cabbage, kacangPanjang, kacang, krupuk, lontong, tahu, telor,
    // Absurd ingredients (traps)
    trapChili, trapFishBone
  ]
}
