//
//  ContentView.swift
//  Crabbylicious
//
//  Debug version
//

import SpriteKit
import SwiftUI

struct ContentView: View {
  var scene: SKScene {
    let screenSize = UIScreen.main.bounds.size

    // Use debug scene temporarily
    let scene = ECSGameScene(size: screenSize)
    scene.scaleMode = .aspectFill
    return scene
  }

  var body: some View {
    SpriteView(scene: scene)
      .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
