//
//  GameViewController.swift
//  Crabbylicious
//
//  Created by Java Kanaya Prada on 16/07/25.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create SKView
    if let view = self.view as! SKView? {
      // Create and present HomeScene
      let scene = HomeScene(size: view.bounds.size)
      scene.scaleMode = .aspectFill
      
      view.presentScene(scene)
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
    }
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
