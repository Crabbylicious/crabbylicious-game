//
//  SoundManager.swift
//  Crabbylicious
//
//  Created by Nessa on 23/07/25.
//

import AVFoundation

class SoundManager {
  static let sound = SoundManager()
  private var audioPlayer: AVAudioPlayer?

  func playCorrectSound() {
    playSound(named: "soundBenar", withExtension: "wav")
  }

  private func playSound(named name: String, withExtension ext: String) {
    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
      print("Sound file not found: \(name).\(ext)")
      return
    }
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
    } catch {
      print("Failed to play sound: \(error.localizedDescription)")
    }
  }
}
