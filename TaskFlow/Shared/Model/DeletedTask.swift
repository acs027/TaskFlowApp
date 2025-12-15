//
//  DeletedTasks.swift
//  TaskFlow
//
//  Created by ali cihan on 15.12.2025.
//

import Foundation

import SwiftData

@Model
class DeletedTask: Identifiable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}
