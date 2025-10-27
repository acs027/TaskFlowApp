//
//  NotificationManager.swift
//  TaskFlow
//
//  Created by ali cihan on 27.10.2025.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static func requestPermission() {
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              if let error = error {
                  print("❌ Notification permission error:", error.localizedDescription)
              } else {
                  print(granted ? "✅ Notifications granted" : "❌ Notifications denied")
                  if granted == false {
                      UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                      clearAllNotifications()
                  } else {
                      UserDefaults.standard.set(true, forKey: "notificationsEnabled")
                  }
              }
          }
      }
    
    static func scheduleDeadlineNotification(for task: TaskItem) {
        let content = UNMutableNotificationContent()
        content.title = "Task Deadline Approaching"
        content.body = "“\(task.title)” is due soon!"
        content.sound = .default

        // Fire 30 minutes before deadline
        let triggerDate = task.deadline.addingTimeInterval(-30 * 60)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("❌ Notification scheduling failed:", error.localizedDescription)
            } else {
                print("⏰ Notification scheduled for \(triggerDate)")
            }
        }
    }
    
    // Remove all pending + delivered notifications
    static func clearAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("🧹 All notifications removed.")
    }

    // Check current permission status
    static func checkStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
}
