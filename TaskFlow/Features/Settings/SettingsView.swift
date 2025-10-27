//
//  SettingsView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//
import SwiftUI

struct SettingsView: View {
    @Environment(UserPreferences.self) var prefs
    @State private var viewModel = SettingsViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                themeSection
                syncSection
                notificationSection
                roleSection
                exportSection
            }
            .navigationTitle("Settings")
            .preferredColorScheme(prefs.theme.colorScheme)
        }
        .onChange(of: prefs.notificationsEnabled) { oldValue, newValue in
            viewModel.handleNotificationChange(for: newValue)
        }
        .onChange(of: prefs) { oldValue, newValue in
            prefs.save()
        }
    }
    
    private var themeSection: some View {
        Section("Appearance") {
            let themeBinding = Binding<UserPreferences.Theme>(
                get: { prefs.theme },
                set: { prefs.theme = $0 }
            )
            Picker("Theme", selection: themeBinding) {
                ForEach(UserPreferences.Theme.allCases) { theme in
                    Text(theme.rawValue.capitalized).tag(theme)
                }
            }
        }
    }
    
    private var syncSection: some View {
        Section("Sync") {
            let offlineBinding = Binding<UserPreferences.OfflineSyncMode>(
                get: { prefs.offlineSync },
                set: { prefs.offlineSync = $0 }
            )
            Picker("Offline Sync", selection: offlineBinding) {
                ForEach(UserPreferences.OfflineSyncMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            let manualBinding = Binding<UserPreferences.ManualSync>(
                get: { prefs.manualSync },
                set: { prefs.manualSync = $0 }
            )
            Picker("Manual Sync", selection: manualBinding) {
                ForEach(UserPreferences.ManualSync.allCases) { sync in
                    Text(sync.rawValue).tag(sync)
                }
            }
        }
    }
    
    private var notificationSection: some View {
        Section("Notifications") {
            let notificationsBinding = Binding<Bool>(
                get: { prefs.notificationsEnabled },
                set: { prefs.notificationsEnabled = $0 }
            )
            Toggle("Enable Notifications", isOn: notificationsBinding)
        }
    }
    
    private var roleSection: some View {
        Section("Role") {
            let roleBinding = Binding<UserRole>(
                get: { prefs.userRole },
                set: { prefs.userRole = $0 }
            )
            Picker("User Role", selection: roleBinding) {
                ForEach(UserRole.allCases) { role in
                    Text(role.rawValue).tag(role)
                }
            }
        }
    }
    
    private var exportSection: some View {
        Section("Data") {
            Button("Export / Import JSON") {
                //TODO
            }
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
