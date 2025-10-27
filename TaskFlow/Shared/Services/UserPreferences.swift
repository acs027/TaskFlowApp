//
//  UserPreferences.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import Foundation
import Observation

enum UserRole: String, CaseIterable, Identifiable {
    case admin = "Admin"
    case technician = "Technician"
    var id: String { rawValue }
}

@Observable
final class UserPreferences {
    // MARK: - Enums
    enum Theme: String, CaseIterable, Identifiable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
        var id: String { rawValue }
    }

    enum OfflineSyncMode: String, CaseIterable, Identifiable {
        case wifiAndCellular = "Wi-Fi or Cellular"
        case wifiOnly = "Wi-Fi Only"
        case off = "Off"
        var id: String { rawValue }
    }

    enum ManualSync: String, CaseIterable, Identifiable {
        case on = "On"
        case off = "Off"
        var id: String { rawValue }
    }
    
    static let shared = UserPreferences()
    
    // MARK: - Properties
    var theme: Theme
    var offlineSync: OfflineSyncMode
    var manualSync: ManualSync
    var notificationsEnabled: Bool
    var userRole: UserRole

    // MARK: - Init
    private init() {
        theme = Theme(rawValue: UserDefaults.standard.string(forKey: "theme") ?? Theme.system.rawValue) ?? .system
        offlineSync = OfflineSyncMode(rawValue: UserDefaults.standard.string(forKey: "offlineSync") ?? OfflineSyncMode.wifiOnly.rawValue) ?? .wifiOnly
        manualSync = ManualSync(rawValue: UserDefaults.standard.string(forKey: "manualSync") ?? ManualSync.off.rawValue) ?? .off
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        userRole = UserRole(rawValue: UserDefaults.standard.string(forKey: "userRole") ?? UserRole.technician.rawValue) ?? .technician
    }

    // MARK: - Save to UserDefaults
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(theme.rawValue, forKey: "theme")
        defaults.set(offlineSync.rawValue, forKey: "offlineSync")
        defaults.set(manualSync.rawValue, forKey: "manualSync")
        defaults.set(notificationsEnabled, forKey: "notificationsEnabled")
        defaults.set(userRole.rawValue, forKey: "userRole")
        print("Preferences Saved!")
    }
}

extension UserPreferences: Equatable {
    static func == (lhs: UserPreferences, rhs: UserPreferences) -> Bool {
        lhs.theme == rhs.theme &&
        lhs.offlineSync == rhs.offlineSync &&
        lhs.manualSync == rhs.manualSync &&
        lhs.notificationsEnabled == rhs.notificationsEnabled &&
        lhs.userRole == rhs.userRole
    }
}
