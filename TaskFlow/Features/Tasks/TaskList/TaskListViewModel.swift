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
    }
}
