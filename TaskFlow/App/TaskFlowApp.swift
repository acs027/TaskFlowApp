//
//  TaskFlowApp.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct TaskFlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    
    init() {
        NotificationManager.requestPermission()
       }

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(UserPreferences.shared)
        }
        .modelContainer(sharedModelContainer)
    }
}
