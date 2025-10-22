//
//  ViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation
import SwiftData



extension TaskDetailView {
    @Observable
    class ViewModel {
        var task: TaskItem
        let context: ModelContext
        var processState: ProcessState = .done
        
        init(task: TaskItem, context: ModelContext) {
            self.task = task
            self.context = context
        }
        
        
        func save() {
            do {
                try context.save()
                debugPrint("Succesfully saved.")
            } catch {
                debugPrint("Error occured while saving.")
            }
            processState = .done
        }
        
        @MainActor
        func deleteCheckListItem(id: UUID) {
            processState = .loading
            task.checklist.removeAll(where: {$0.id == id})
            save()
        }
        
        func addCheckListItem(for itemTitle: String) {
            processState = .loading
            if !itemTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let item = ChecklistItem(title: itemTitle)
                task.checklist.append(item)
                save()
            } else {
                processState = .done
            }
        }
    }
}
