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
        let context: ModelContext
        var tasks: [TaskItem] = []
        
        init(context: ModelContext) {
            self.context = context
            fetchData()
        }
        
        func loadMockData() {
//            let task = Task(title: "Task", location: .init(name: "Location", latitude: 100, longitude: 100), deadline: .distantFuture, assignedUnit: "Acs")
//            tasks.append(task)
        }
        
        func fetchData() {
                 do {
                     let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\.title)])
                     tasks = try context.fetch(descriptor)
                 } catch {
                     print("Fetch failed")
                 }
             }
    }
}
