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
  static let kacangPanjang = Ingredient(imageName: "kacangPanjang", name: "kacang panjang", isAbsurd: false)
  static let kacang = Ingredient(imageName: "kacang", name: "kacang", isAbsurd: false)
  static let krupuk = Ingredient(imageName: "krupuk", name: "krupuk", isAbsurd: false)
  static let lontong = Ingredient(imageName: "lontong", name: "lontong", isAbsurd: false)
  static let tahu = Ingredient(imageName: "tahu", name: "tahu", isAbsurd: false)
  static let telor = Ingredient(imageName: "telor", name: "telor", isAbsurd: false)
  static let daging = Ingredient(imageName: "daging", name: "daging", isAbsurd: false)
  static let mie = Ingredient(imageName: "mie", name: "mie", isAbsurd: false)
  static let nasi = Ingredient(imageName: "nasi", name: "nasi", isAbsurd: false)
  static let chili = Ingredient(imageName: "cabai", name: "cabai", isAbsurd: false)

  // Absurd ingredients (traps)
  static let trapFishBone = Ingredient(imageName: "fishBone", name: "fish bone", isAbsurd: true)

  static let recipes = [
    Recipe(name: "Gado-Gado", ingredients: [
      cabbage: 2,
      kacangPanjang: 2,
      kacang: 4,
      lontong: 3,
      tahu: 3
    ]),
    Recipe(name: "Bakso", ingredients: [
      daging: 4,
      mie: 2,
      cabbage: 1,
      telor: 1,
      krupuk: 2
    ]),
    Recipe(name: "Mie Instan", ingredients: [
      mie: 4,
      telor: 2,
      cabbage: 1,
      chili: 1
    ]),
    Recipe(name: "Ayam Geprek", ingredients: [
      nasi: 3,
      telor: 2,
      cabbage: 1,
      chili: 3,
      krupuk: 2
    ])
  ]

  static let allIngredients = [
    // Valid ingredients
    cabbage, kacangPanjang, kacang, krupuk, lontong, tahu, telor, daging, mie, nasi,
    // Absurd ingredients (traps)
    chili, trapFishBone
  ]
}
