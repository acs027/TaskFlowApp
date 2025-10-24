//
//  SettingsView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//
import SwiftUI

struct SettingsView: View {
    @State private var prefs = UserPreferences()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $prefs.theme) {
                        ForEach(UserPreferences.Theme.allCases) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
                    }
                }
                
                Section("Sync") {
                    Picker("Offline Sync", selection: $prefs.offlineSync) {
                        ForEach(UserPreferences.OfflineSyncMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    Picker("Manual Sync", selection: $prefs.manualSync) {
                        ForEach(UserPreferences.ManualSync.allCases) { sync in
                            Text(sync.rawValue).tag(sync)
                        }
                    }
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $prefs.notificationsEnabled)
                    if prefs.notificationsEnabled {
                        Toggle("Deadline Alerts", isOn: $prefs.notifyOnDeadline)
                        Toggle("Assignment Alerts", isOn: $prefs.notifyOnAssignment)
                        Toggle("Checklist Updates", isOn: $prefs.notifyOnChecklistChange)
                    }
                }
                
                Section("Role") {
                    Picker("User Role", selection: $prefs.userRole) {
                        ForEach(UserPreferences.UserRole.allCases) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                }
                
                Section("Data") {
                    Button("Export / Import JSON") {
                        //TODO
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(prefs.theme.colorScheme)
        }
    }
}

#Preview {
    SettingsView()
}

extension UserPreferences.Theme {
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil // Follows system
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
