//
//  HapticManager.swift
//  Crabbylicious
//
//  Created by Nessa on 23/07/25.
//

import CoreHaptics

class HapticManager {
  private var engine: CHHapticEngine?
  static let haptic = HapticManager()

  init() {
    prepareHaptics()
  }

  func playFailureHaptic() {
    playHapticPattern(events: [
      CHHapticEvent(eventType: .hapticTransient, parameters: [
        .init(parameterID: .hapticIntensity, value: 1),
        .init(parameterID: .hapticSharpness, value: 1)
      ], relativeTime: 0),
      CHHapticEvent(eventType: .hapticTransient, parameters: [
        .init(parameterID: .hapticIntensity, value: 0.8),
        .init(parameterID: .hapticSharpness, value: 0.8)
      ], relativeTime: 0.1),
      CHHapticEvent(eventType: .hapticTransient, parameters: [
        .init(parameterID: .hapticIntensity, value: 0.6),
        .init(parameterID: .hapticSharpness, value: 0.6)
      ], relativeTime: 0.2)
    ])
  }

  func playSuccessHaptic() {
    playHapticPattern(events: [
      CHHapticEvent(eventType: .hapticTransient, parameters: [
        .init(parameterID: .hapticIntensity, value: 0.4),
        .init(parameterID: .hapticSharpness, value: 0.4)
      ], relativeTime: 0)
    ])
  }

  func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        self.engine = try CHHapticEngine()
        try self.engine?.start()
      } catch {
        print("Error starting haptic engine: \(error.localizedDescription)")
      }
    }
  }

  func playHapticPattern(events: [CHHapticEvent]) {
    do {
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try engine?.makePlayer(with: pattern)
      try player?.start(atTime: 0)
    } catch {
      print("Failed to play haptic: \(error.localizedDescription)")
    }
  }
}
