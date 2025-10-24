//
//  UserPreferences.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import Foundation
import Observation

@Observable
class UserPreferences {
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

    enum UserRole: String, CaseIterable, Identifiable {
        case admin = "Admin"
        case technician = "Technician"
        var id: String { rawValue }
    }

    // MARK: - Properties
    var theme: Theme
    var offlineSync: OfflineSyncMode
    var manualSync: ManualSync
    var notificationsEnabled: Bool
    var notifyOnDeadline: Bool
    var notifyOnAssignment: Bool
    var notifyOnChecklistChange: Bool
    var userRole: UserRole

    // MARK: - Init
    init() {
        theme = Theme(rawValue: UserDefaults.standard.string(forKey: "theme") ?? Theme.system.rawValue) ?? .system
        offlineSync = OfflineSyncMode(rawValue: UserDefaults.standard.string(forKey: "offlineSync") ?? OfflineSyncMode.wifiOnly.rawValue) ?? .wifiOnly
        manualSync = ManualSync(rawValue: UserDefaults.standard.string(forKey: "manualSync") ?? ManualSync.off.rawValue) ?? .off
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        notifyOnDeadline = UserDefaults.standard.bool(forKey: "notifyOnDeadline")
        notifyOnAssignment = UserDefaults.standard.bool(forKey: "notifyOnAssignment")
        notifyOnChecklistChange = UserDefaults.standard.bool(forKey: "notifyOnChecklistChange")
        userRole = UserRole(rawValue: UserDefaults.standard.string(forKey: "userRole") ?? UserRole.technician.rawValue) ?? .technician
    }

    // MARK: - Save to UserDefaults
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(theme.rawValue, forKey: "theme")
        defaults.set(offlineSync.rawValue, forKey: "offlineSync")
        defaults.set(manualSync.rawValue, forKey: "manualSync")
        defaults.set(notificationsEnabled, forKey: "notificationsEnabled")
        defaults.set(notifyOnDeadline, forKey: "notifyOnDeadline")
        defaults.set(notifyOnAssignment, forKey: "notifyOnAssignment")
        defaults.set(notifyOnChecklistChange, forKey: "notifyOnChecklistChange")
        defaults.set(userRole.rawValue, forKey: "userRole")
    }
}
