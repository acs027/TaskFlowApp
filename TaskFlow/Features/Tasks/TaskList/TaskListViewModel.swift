//
//  ViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation
import SwiftData

extension TaskListView {
    @Observable
    class ViewModel {
        private let context: ModelContext
        var tasks: [TaskItem] = []
        
        var completedTasks: [TaskItem] {
            tasks.filter({ $0.taskState == .completed })
        }
        
        var remainingTasks: [TaskItem] {
            tasks.filter({$0.taskState != .completed})
        }
        
        init(context: ModelContext) {
            self.context = context
            fetchData()
        }
        
        func fetchData() {
                 do {
                     let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\.deadline)])
                     tasks = try context.fetch(descriptor)
                 } catch {
                     print("Fetch failed")
                 }
             }
        
        func insertMockData() {
            for item in TaskItem.mockData {
                context.insert(item)
            }
            do {
                try context.save()
            } catch {
                print("Inserting mock data failed.")
            }
        }
        
        func deleteTask(task: TaskItem) {
            context.delete(task)
            let deletedTask = DeletedTask(id: task.id)
            context.insert(deletedTask)
            fetchData()
        }
    }
}
