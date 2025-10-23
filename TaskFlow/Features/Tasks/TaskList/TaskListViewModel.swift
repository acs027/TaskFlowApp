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
        private let syncManager: TaskSyncManager
        var tasks: [TaskItem] = []
        
        init(context: ModelContext) {
            self.context = context
            self.syncManager = TaskSyncManager(context: context)
            fetchData()
        }
        
        func loadMockData() {
//            let task = Task(title: "Task", location: .init(name: "Location", latitude: 100, longitude: 100), deadline: .distantFuture, assignedUnit: "Acs")
//            tasks.append(task)
        }
        
        func fetchData() {
                 do {
                     let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\.deadline)])
                     tasks = try context.fetch(descriptor)
                 } catch {
                     print("Fetch failed")
                 }
             }
        
        func sync() async {
            await syncManager.syncFirebaseToLocal()
            await syncManager.syncLocalToFirebase()
            fetchData()
        }
    }
}
