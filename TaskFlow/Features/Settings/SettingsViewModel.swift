//
//  SettingsViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 27.10.2025.
//

import Foundation
import FirebaseAuth

@Observable
class SettingsViewModel {
    func handleNotificationChange(for value: Bool) {
        if value {
            NotificationManager.requestPermission()
        } else {
            NotificationManager.clearAllNotifications()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logout success")
        } catch {
            print("Error occured while logout.")
        }
        
    }
}
