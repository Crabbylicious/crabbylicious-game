import SpriteKit

protocol ConfirmPopupOverlayDelegate: AnyObject {
  func didConfirmYes()
  func didConfirmNo()
}

class ConfirmPopupOverlay: SKNode {
  weak var delegate: ConfirmPopupOverlayDelegate?
  private var background: SKShapeNode!
  private var label: SKLabelNode!
  private var labelKecil1: SKLabelNode!
  private var labelKecil2: SKLabelNode!
  private var yesButton: ButtonNode!
  private var noButton: ButtonNode!
  private let popupSize: CGSize
  private var border: SKSpriteNode!

  init(size: CGSize) {
    popupSize = size
    super.init()
    setupPopup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupPopup() {
    border = SKSpriteNode(imageNamed: "BorderAreYouSure")
    border.position = CGPoint(x: 0, y: popupSize.height * 0.1)
    border.zPosition = 10
    border.setScale(0.45)
    addChild(border)

    // Yes button
    yesButton = ButtonNode(imageName: "ButtonYes", scale: 0.18)
    yesButton.position = CGPoint(x: -popupSize.width / 4 + 10, y: -popupSize.height / 4 + 30)
    yesButton.setScale(0.2)
    yesButton.name = "yesButton"
    yesButton.zPosition = 10
    addChild(yesButton)

    // No button
    noButton = ButtonNode(imageName: "ButtonNo", scale: 0.18)
    noButton.position = CGPoint(x: popupSize.width / 4 - 10, y: -popupSize.height / 4 + 30)
    noButton.setScale(0.2)
    noButton.name = "noButton"
    noButton.zPosition = 10
    addChild(noButton)

    alpha = 0
    isUserInteractionEnabled = false
  }

  func show() {
    isUserInteractionEnabled = true
    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
    run(fadeIn)
    yesButton.alpha = 0
    noButton.alpha = 0
    yesButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.2),
      SKAction.fadeIn(withDuration: 0.2)
    ]))
    noButton.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.3),
      SKAction.fadeIn(withDuration: 0.2)
    ]))
  }

  override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let touchedNode = atPoint(location)
    switch touchedNode.name {
    case "yesButton":
      animateButtonPress(touchedNode) {
        SoundManager.sound.stopInGameMusic()
        SoundManager.sound.allButtonSound()
        self.delegate?.didConfirmYes()
      }
    case "noButton":
      animateButtonPress(touchedNode) {
        SoundManager.sound.allButtonSound()
        self.delegate?.didConfirmNo()
      }
    default:
      break
    }
  }
}
