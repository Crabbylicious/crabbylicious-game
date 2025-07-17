//
//  ContentView.swift
//  Crabbylicious
//
//  Created by Nessa on 17/07/25.
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
      .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
