//
//  ViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation

extension TaskListView {
    @Observable
    class ViewModel {
        
        var tasks: [Task] = []
        
        func loadMockData() {
//            let task = Task(title: "Task", location: .init(name: "Location", latitude: 100, longitude: 100), deadline: .distantFuture, assignedUnit: "Acs")
//            tasks.append(task)
        }
    }
}
