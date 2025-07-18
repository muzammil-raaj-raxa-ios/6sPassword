//
//  UserDefaultsManager.swift
//  PasswordLock
//
//  Created by r a a j on 15/07/2025.
//

import Foundation
import WidgetKit

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let selectedTime = "selectedTime"
        static let selectedRounds = "selectedRounds"
        static let totalGames = "totalGames"
        static let bestStreak = "bestStreak"
        static let bestAccuracy = "bestAccuracy"
        static let fastestTime = "fastestTime"
        static let tapSoundEnabled = "tapSoundEnabled"
        static let tapHapticEnabled = "tapHapticEnabled"
    }
    
    var selectedTime: String? {
        get { return defaults.string(forKey: Keys.selectedTime) }
        set { defaults.set(newValue, forKey: Keys.selectedTime) }
    }
    
    var selectedRounds: String? {
        get { return defaults.string(forKey: Keys.selectedRounds) }
        set { defaults.set(newValue, forKey: Keys.selectedRounds) }
    }
    
    var totalGames: String? {
        get { return defaults.string(forKey: Keys.totalGames) }
        set { defaults.set(newValue, forKey: Keys.totalGames) }
    }
    
    var bestStreak: String? {
        get { return defaults.string(forKey: Keys.bestStreak) }
        set { defaults.set(newValue, forKey: Keys.bestStreak) }
    }
    
    var bestAccuracy: String? {
        get { return defaults.string(forKey: Keys.bestAccuracy) }
        set { defaults.set(newValue, forKey: Keys.bestAccuracy) }
    }
    
    var fastestTime: String? {
        get { return defaults.string(forKey: Keys.fastestTime) }
        set { defaults.set(newValue, forKey: Keys.fastestTime) }
    }
    
    var tapSoundEnabled: Bool {
        get {
            if defaults.object(forKey: Keys.tapSoundEnabled) == nil {
                defaults.set(true, forKey: Keys.tapSoundEnabled) // First time default
            }
            return defaults.bool(forKey: Keys.tapSoundEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.tapSoundEnabled)
        }
    }
    
    var tapHapticEnabled: Bool {
        get {
            if defaults.object(forKey: Keys.tapHapticEnabled) == nil {
                defaults.set(true, forKey: Keys.tapHapticEnabled)
            }
            return defaults.bool(forKey: Keys.tapHapticEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.tapHapticEnabled)
        }
    }
    
    
    // MARK: - Clear All
    func clearAll() {
        let keys = [
            Keys.selectedTime,
            Keys.selectedRounds,
            Keys.totalGames,
            Keys.bestStreak,
            Keys.bestAccuracy,
            Keys.fastestTime,
            Keys.tapSoundEnabled,
            Keys.tapHapticEnabled,
        ]
        keys.forEach { defaults.removeObject(forKey: $0) }
    }
}
