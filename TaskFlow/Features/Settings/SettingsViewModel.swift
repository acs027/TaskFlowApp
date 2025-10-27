//
//  SettingsViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 27.10.2025.
//

import Foundation


@Observable
class SettingsViewModel {
    
    //TODO notification change
    func handleNotificationChange(for value: Bool) {
        if value {
            NotificationManager.requestPermission()
        } else {
            NotificationManager.clearAllNotifications()
        }
    }
}
