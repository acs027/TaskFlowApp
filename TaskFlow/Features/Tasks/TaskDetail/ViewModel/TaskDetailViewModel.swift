//
//  ViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation

extension TaskDetailView {
    @Observable
    class ViewModel {
        var task: TaskItem
        
        init(task: TaskItem) {
            self.task = task
        }
        
    }
}
