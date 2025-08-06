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

  // Tambahan untuk background music lobby
  private var lobbyMusicPlayer: AVAudioPlayer?
  // Tambahan untuk background music in-game
  private var inGameMusicPlayer: AVAudioPlayer?

  func playCorrectSound() {
    playSound(named: "soundBenar", withExtension: "wav")
  }

  func playWrongSound() {
    playSound(named: "soundSalah", withExtension: "wav")
  }

  func startButtonSound() {
    playSound(named: "startButtonSound", withExtension: "wav")
  }

  func allButtonSound() {
    playSound(named: "allButtonSound", withExtension: "wav")
  }

  func bubbleSound() {
    playSound(named: "bubbleSound", withExtension: "wav")
  }

  func gameOverSound() {
    playSound(named: "gameOverSound", withExtension: "wav")
  }

  func winSound() {
    playSound(named: "soundMenang", withExtension: "wav")
  }

  // MARK: - Lobby Music

  func playLobbyMusic() {
    guard let url = Bundle.main.url(forResource: "lobbyMusic", withExtension: "wav") else {
      print("Lobby music file not found.")
      return
    }
    do {
      lobbyMusicPlayer = try AVAudioPlayer(contentsOf: url)
      lobbyMusicPlayer?.numberOfLoops = -1 // Loop forever
      lobbyMusicPlayer?.volume = 1.0
      lobbyMusicPlayer?.prepareToPlay()
      lobbyMusicPlayer?.play()
    } catch {
      print("Failed to play lobby music: \(error.localizedDescription)")
    }
  }

  func stopLobbyMusic() {
    lobbyMusicPlayer?.stop()
    lobbyMusicPlayer = nil
  }

  // MARK: - In-Game Music

  func playInGameMusic() {
    guard let url = Bundle.main.url(forResource: "inGameMusic", withExtension: "wav") else {
      print("In-game music file not found.")
      return
    }
    do {
      inGameMusicPlayer = try AVAudioPlayer(contentsOf: url)
      inGameMusicPlayer?.numberOfLoops = -1 // Loop forever
      inGameMusicPlayer?.volume = 0.2
      inGameMusicPlayer?.prepareToPlay()
      inGameMusicPlayer?.play()
    } catch {
      print("Failed to play in-game music: \(error.localizedDescription)")
    }
  }

  func stopInGameMusic() {
    inGameMusicPlayer?.stop()
    inGameMusicPlayer = nil
  }

  private func playSound(named name: String, withExtension ext: String) {
    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
      print("Sound file not found: \(name).\(ext)")
      return
    }
    do {
      if name == "allButtonSound" || name == "startButtonSound" {
        audioPlayer?.volume = 2.0
      } else if name == "soundMenang" {
        audioPlayer?.volume = 0.1
      }
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
    } catch {
      print("Failed to play sound: \(error.localizedDescription)")
    }
  }

  func stopSound() {
    audioPlayer?.stop()
  }
}
