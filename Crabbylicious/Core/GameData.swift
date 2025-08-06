//
//  GameData.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import Foundation

class GameData {
  // Valid ingredients
  static let cabbage = Ingredient(imageName: "kubis", name: "kubis", isAbsurd: false, scale: 0.1)
  static let kacangPanjang = Ingredient(imageName: "kacangPanjang", name: "kacang panjang", isAbsurd: false, scale: 0.1)
  static let kacang = Ingredient(imageName: "kacang", name: "kacang", isAbsurd: false, scale: 0.07)
  static let krupuk = Ingredient(imageName: "krupuk", name: "krupuk", isAbsurd: false, scale: 0.12)
  static let lontong = Ingredient(imageName: "lontong", name: "lontong", isAbsurd: false, scale: 0.11)
  static let tahu = Ingredient(imageName: "tahu", name: "tahu", isAbsurd: false, scale: 0.1)
  static let telor = Ingredient(imageName: "telor", name: "telor", isAbsurd: false, scale: 0.1)
  static let daging = Ingredient(imageName: "daging", name: "daging", isAbsurd: false, scale: 0.15)
  static let mie = Ingredient(imageName: "mie", name: "mie", isAbsurd: false, scale: 0.13)
  static let nasi = Ingredient(imageName: "nasi", name: "nasi", isAbsurd: false, scale: 0.15)
  static let chili = Ingredient(imageName: "Cabai", name: "cabai", isAbsurd: false, scale: 0.1)
  static let ayam = Ingredient(imageName: "chicken", name: "ayam", isAbsurd: false, scale: 0.13)

  // Absurd ingredients (traps)
  static let trapFishBone = Ingredient(imageName: "fishBone", name: "fish bone", isAbsurd: true, scale: 0.09)

  static let recipes = [
    Recipe(name: "Gado-Gado", ingredients: [
      cabbage: 1
//      kacangPanjang: 2,
//      kacang: 4,
//      lontong: 3,
//      tahu: 3
    ]),
    Recipe(name: "Bakso", ingredients: [
      daging: 4,
      mie: 2,
      cabbage: 1,
      tahu: 2,
      lontong: 1
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
      ayam: 2,
      chili: 3,
      krupuk: 1
    ])
  ]

  static let allIngredients = [
    // Valid ingredients
    cabbage, kacangPanjang, kacang, krupuk, lontong, tahu, telor, daging, mie, ayam, nasi,
    // Absurd ingredients (traps)
    chili, trapFishBone
  ]
}
