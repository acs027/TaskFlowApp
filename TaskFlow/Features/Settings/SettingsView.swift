//
//  SettingsView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//
import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @Environment(AuthViewModel.self) var authViewModel
    @AppStorage("theme") var themeRawValue: String = Theme.system.rawValue
    @AppStorage("offlineSync") var offlineSyncRawValue: String = OfflineSyncMode.wifiOnly.rawValue
    @AppStorage("manualSync") var manualSyncRawValue: String = ManualSync.off.rawValue
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("userRole") var userRoleRawValue: String = UserRole.technician.rawValue
    
    var body: some View {
        NavigationStack {
            Form {
                themeSection
                syncSection
                notificationSection
                roleSection
                exportSection
                logoutSection
            }
            .navigationTitle("Settings")
            .preferredColorScheme(Theme(rawValue: themeRawValue)?.colorScheme)
        }
        .onChange(of: notificationsEnabled) { oldValue, newValue in
            viewModel.handleNotificationChange(for: newValue)
        }
    }
    
    private var themeSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $themeRawValue) {
                ForEach(Theme.allCases) { theme in
                    Text(theme.rawValue.capitalized).tag(theme)
                }
            }
        }
    }
    
    private var syncSection: some View {
        Section("Sync") {
            Picker("Offline Sync", selection: $offlineSyncRawValue) {
                ForEach(OfflineSyncMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            Picker("Manual Sync", selection: $manualSyncRawValue) {
                ForEach(ManualSync.allCases) { sync in
                    Text(sync.rawValue).tag(sync)
                }
            }
        }
    }
    
    private var notificationSection: some View {
        Section("Notifications") {
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
        }
    }
    
    private var roleSection: some View {
        Section("Role") {
            Picker("User Role", selection: $userRoleRawValue) {
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
    
    private var logoutSection: some View {
        Section("Logout") {
            Button("Logout") {
                authViewModel.logout()
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension Theme {
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
