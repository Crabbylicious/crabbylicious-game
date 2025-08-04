//
//  GameFont.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 04/08/25.
//

import SpriteKit

enum GameFontColor {
  case primary // White
  case secondary // Gray
  case accent // Theme red
  case highlight // Yellow
  case success // Green
  case danger // Red

  var color: SKColor {
    switch self {
    case .primary: .white
    case .secondary: .gray
    case .accent: .themeRed
    case .highlight: .yellow
    case .success: .green
    case .danger: .red
    }
  }
}

enum GameFontSize {
  case small // 8pt
  case medium // 12pt
  case large // 16pt
  case extraLarge // 20pt
  case title // 24pt

  var points: CGFloat {
    switch self {
    case .small: 8
    case .medium: 12
    case .large: 16
    case .extraLarge: 20
    case .title: 24
    }
  }
}
