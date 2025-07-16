//
//  GameViewController.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import SpriteKit
import UIKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if let view = view as! SKView? {
      // Load the SKScene from 'GameScene.sks'

      let scene = GameScene(size: CGSize(width: 1536, height: 2048))
      // Set the scale mode to scale to fit the window
      scene.scaleMode = .aspectFill

      // Present the scene
      view.presentScene(scene)

      view.ignoresSiblingOrder = true

      view.showsFPS = true
      view.showsNodeCount = true
    }
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    .portrait
  }

  override var prefersStatusBarHidden: Bool {
    true
  }
}
