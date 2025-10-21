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
        
        func itemCount(for taskState: TaskState, context: ModelContext) -> Int {
            do {
                let descriptor = FetchDescriptor<TaskItem>(predicate: #Predicate<TaskItem> { item in
                    item.taskState == taskState
                })
                let result = try context.fetchCount(descriptor)
                return result
            } catch {
                print(error.localizedDescription)
            }
            return 0
        }
    }
}
