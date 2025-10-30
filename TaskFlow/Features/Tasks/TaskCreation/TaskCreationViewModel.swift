//
//  TaskCreationViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import Foundation
import Observation
import SwiftData

extension TaskCreationView {
    @Observable
    final class ViewModel {
        // Required variables
        var title: String = ""
        var location: Location?
        var deadline: Date = .now
        var assignedUnit: String = ""
        var taskState: TaskState = .initial
        
        // Optionals
        var category: String = ""
        var priority: Priority?
        var checkList: String = ""
        var description: String = ""
        
        let context: ModelContext
        
        var isAlertShowing: Bool = false
        var errorMessage: String = ""
        
        init(context: ModelContext) {
            self.context = context
        }
        
        //TODO: I will figure out how we get checklist while task creation
        //TextEditor Checklist section, cast them CheckListItem with new line seperator
        func saveTask(isNotificationOn: Bool, completion: @escaping () -> Void) {
                if isValid() {
                    do {
                        let item = TaskItem(id: UUID(), title: title, location: location!, deadline: deadline, assignedUnit: assignedUnit, category: category, priority: priority, taskDescription: description, taskState: taskState)
                        context.insert(item)
                        try context.save()
                        print("saved")
                        if isNotificationOn {
                            NotificationManager.scheduleDeadlineNotification(for: item)
                        }
                        completion()
                    } catch {
                        print(error.localizedDescription)
                        
                    }
                } else {
                    isAlertShowing.toggle()
                }
        }
        
        func isValid() -> Bool {
               guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                   errorMessage = "Title is missing"
                   return false }
               guard !assignedUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                   errorMessage = "Assigned unit is missing"
                   return false }
               guard location != nil else {
                   errorMessage = "Location is missing"
                   return false }
               guard deadline > Date() else {
                   errorMessage = "Date is missing"
                   return false }
               
               return true
           }
    }
}
