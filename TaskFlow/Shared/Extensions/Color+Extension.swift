//
//  Color+Extension.swift
//  TaskFlow
//
//  Created by ali cihan on 23.10.2025.
//

import SwiftUI

extension Color {
    static func backgroundColor(for task: TaskItem) -> Color {
        let now = Date()
        let timeInterval = task.deadline.timeIntervalSince(now)
        
        if timeInterval < 0 {
            return Color.red.opacity(0.8) // overdue
        } else if timeInterval < 24 * 60 * 60 { // within 1 day
            return Color.red.opacity(0.5)
        } else if timeInterval < 3 * 24 * 60 * 60 { // within 3 days
            return Color.orange.opacity(0.3)
        } else {
            return Color.clear
        }
    }
}
