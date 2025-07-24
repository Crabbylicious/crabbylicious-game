import SpriteKit

protocol PauseOverlayDelegate: AnyObject {
  func didTapResume()
  func didTapBackHome()
}

class PauseOverlay: SKNode {
  weak var delegate: PauseOverlayDelegate?
  let buttonScale: CGFloat = 0.3

  private var backgroundOverlay: SKSpriteNode!
  private var crabPauseSprite: SKSpriteNode!
  private var resumeButton: ButtonNode!
  private var backHomeButton: ButtonNode!
  private let overlaySize: CGSize
  private var confirmPopup: ConfirmPopupOverlay?

  init(size: CGSize) {
    overlaySize = size
    super.init()
    setupOverlay()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupOverlay() {
    backgroundOverlay = SKSpriteNode(color: SKColor.black, size: overlaySize)
    backgroundOverlay.alpha = 0.7
    backgroundOverlay.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2)
    backgroundOverlay.zPosition = 10
    addChild(backgroundOverlay)

    crabPauseSprite = SKSpriteNode(imageNamed: "BolderPause")
    crabPauseSprite.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2 + 5)
    crabPauseSprite.zPosition = 10
    crabPauseSprite.setScale(0.38)
    addChild(crabPauseSprite)

    let unifiedSize = CGSize(width: 140, height: 50)
    let spacing: CGFloat = 10

    // Resume button
    resumeButton = ButtonNode(imageName: "ButtonResume", scale: buttonScale)
    resumeButton.name = "resumeButton"
    resumeButton.zPosition = 10
    resumeButton.size = unifiedSize
    resumeButton.position = CGPoint(
      x: overlaySize.width / 2,
      y: overlaySize.height / 2 + 20
    )
    addChild(resumeButton)

    // Home button
    backHomeButton = ButtonNode(imageName: "ButtonBackHome", scale: buttonScale)
    backHomeButton.name = "backHomeButton"
    backHomeButton.zPosition = 10
    backHomeButton.size = CGSize(width: 130, height: 45)
    backHomeButton.position = CGPoint(
      x: resumeButton.position.x,
      y: resumeButton.position.y - unifiedSize.height - spacing
    )
    addChild(backHomeButton)

    // Initially hidden
    alpha = 0
    isUserInteractionEnabled = false
  }

  func show() {
    isUserInteractionEnabled = true
    resumeButton.alpha = 0
    backHomeButton.alpha = 0
    crabPauseSprite.alpha = 0
    let fadeIn = SKAction.fadeIn(withDuration: 0.3)
    run(fadeIn)
    crabPauseSprite.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKAction.fadeIn(withDuration: 0.3)
    ]))
    resumeButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.2),
      SKAction.fadeIn(withDuration: 0.3)
    ]))
    backHomeButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.3),
      SKAction.fadeIn(withDuration: 0.3)
    ]))
  }

  func hide() {
    isUserInteractionEnabled = false
    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
    run(fadeOut)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let touchedNode = atPoint(location)
    switch touchedNode.name {
    case "resumeButton":
      animateButtonPress(touchedNode) {
        self.delegate?.didTapResume()
      }
    case "backHomeButton":
      animateButtonPress(touchedNode) {
        self.showConfirmPopup()
      }
    default:
      break
    }
  }

  private func showConfirmPopup() {
    if confirmPopup == nil {
      confirmPopup = ConfirmPopupOverlay(size: CGSize(width: overlaySize.width * 0.7, height: 220))
      confirmPopup?.position = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2)
      confirmPopup?.zPosition = 100
      confirmPopup?.delegate = self
      addChild(confirmPopup!)
      confirmPopup?.show()
    }
  }
}

extension PauseOverlay: ConfirmPopupOverlayDelegate {
  func didConfirmYes() {
    confirmPopup?.removeFromParent()
    confirmPopup = nil
    delegate?.didTapBackHome()
  }

  func didConfirmNo() {
    confirmPopup?.removeFromParent()
    confirmPopup = nil
  }
}
