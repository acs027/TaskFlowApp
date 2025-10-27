//
//  ViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation
import SwiftData

extension DashboardView {
    @Observable
    class ViewModel {
        var tasks: [TaskItem] = []
        var counts: [TaskState: Int] = [:]
        private let syncManager: TaskSyncManager
        let context: ModelContext
        
        init(context: ModelContext) {
            self.context = context
            self.syncManager = TaskSyncManager(context: context)
        }
        
        func fetchTaskCounts(context: ModelContext) {
            do {
                // Fetch all tasks (single database call)
                let descriptor = FetchDescriptor<TaskItem>()
                let allTasks = try context.fetch(descriptor)
                
                // Group by taskState and count
                counts = Dictionary(
                    grouping: allTasks,
                    by: { $0.taskState }
                ).mapValues { $0.count }
                
            } catch {
                debugPrint("⚠️ Failed to fetch task counts: \(error)")
                counts = [:]
            }
        }
        
        func count(for state: TaskState) -> Int {
            counts[state] ?? 0
        }
        
        private func sync() async {
            await syncManager.syncFirebaseToLocal()
            await syncManager.syncLocalToFirebase()
        }
    }
}
