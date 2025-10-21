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
        var controlList: String = ""
        var description: String = ""
        
        let context: ModelContext
        
        var isAlertShowing: Bool = false
        
        init(context: ModelContext) {
            self.context = context
        }
        
        func saveTask() {
                if isValid() {
                    do {
                        let item = TaskItem(id: UUID(), title: title, location: location!, deadline: deadline, assignedUnit: assignedUnit, category: category, priority: priority, taskDescription: description, taskState: taskState, todoList: controlList)
                        context.insert(item)
                        try context.save()
                        print("saved")
                    } catch {
                        print(error.localizedDescription)
                        
                    }
                } else {
                    isAlertShowing.toggle()
                }
        }
        
        func isValid() -> Bool {
               guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
               guard !assignedUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
               guard location != nil else { return false }
               guard deadline > Date() else { return false }
               
               return true
           }
    }
}
