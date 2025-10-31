//
//  ViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation
import SwiftData
import Network

extension DashboardView {
    @Observable
    class ViewModel {
        var tasks: [TaskItem] = []
        var counts: [TaskState: Int] = [:]
        private let syncManager: TaskSyncManager
        let context: ModelContext
        
        var isSyncing: Bool = false
        
        init(context: ModelContext) {
            self.context = context
            self.syncManager = TaskSyncManager(context: context)
            fetchTaskCounts()
        }
        
        func fetchTaskCounts() {
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
            if state == .planned {
                return (counts[state] ?? 0) + (counts[.todo] ?? 0)
            } else if state == .ongoing {
                return (counts[state] ?? 0) + (counts[.review] ?? 0)
            }
            return counts[state] ?? 0
        }
        
        func sync() async {
            isSyncing = true
            await syncManager.syncFirebaseToLocal()
            await syncManager.syncLocalToFirebase()
            fetchTaskCounts()
            isSyncing = false
        }
        
        
        func checkForSync(for type: NWInterface.InterfaceType?, isConnected: Bool?) async {
            
            if let type, let isConnected {
                let storedValue = UserDefaults.standard.string(forKey: "offlineSync")
                let offlineSyncMode = OfflineSyncMode(rawValue: storedValue ?? "") ?? .off
                if offlineSyncMode.types().contains(type) {
                            await sync()
                        
                }
            }
        }
    }
}
