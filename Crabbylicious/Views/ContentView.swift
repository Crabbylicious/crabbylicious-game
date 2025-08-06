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
    let scene = GameScene(size: screenSize)
    scene.scaleMode = .aspectFill
    return scene
  }

  var body: some View {
    SpriteView(scene: scene)
      .edgesIgnoringSafeArea(.all)
      .statusBar(hidden: true)
  }
}

#Preview {
  ContentView()
}
