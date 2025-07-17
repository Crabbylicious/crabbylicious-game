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
    let scene = GameScene(size: CGSize(width: 1536, height: 2048))
    scene.size = CGSize(width: 1536, height: 2048)
    scene.scaleMode = .fill
    return scene
  }

  var body: some View {
    SpriteView(scene: scene)
      .frame(width: 1536, height: 2048)
      .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
