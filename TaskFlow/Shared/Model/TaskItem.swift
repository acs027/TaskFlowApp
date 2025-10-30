//
//  Task.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import Foundation
import SwiftData

@Model
class TaskItem: Identifiable {
    var id: UUID = UUID()
    
    var title: String
    var location: Location
    var deadline: Date
    var assignedUnit: String
    
    var category: String?
    var priority: Priority?
    
    @Relationship(deleteRule: .cascade)
    var checklist: [ChecklistItem] = []
    
    var taskDescription: String
    
    var taskState: TaskState
    
    @Relationship(deleteRule: .cascade)
    var inProgressContent: [WorkItem] = []
    
    init(id: UUID,
         title: String,
         location: Location,
         deadline: Date,
         assignedUnit: String,
         category: String? = nil,
         priority: Priority? = nil,
         taskDescription: String,
         taskState: TaskState,
         inProgressContent: [WorkItem] = [],
         checklist: [ChecklistItem] = []) {
        self.id = id
        self.title = title
        self.location = location
        self.deadline = deadline
        self.assignedUnit = assignedUnit
        self.category = category
        self.priority = priority
        self.taskDescription = taskDescription
        self.taskState = taskState
        self.inProgressContent = inProgressContent
        self.checklist = checklist
    }
}

@Model
class ChecklistItem: Identifiable {
    var id: UUID = UUID()
    var title: String
    var isChecked: Bool
    
    @Relationship(inverse: \TaskItem.checklist)
    var task: TaskItem?
    
    init(title: String, isChecked: Bool = false, task: TaskItem? = nil) {
        self.title = title
        self.isChecked = isChecked
        self.task = task
    }
}

@Model
class Location: Identifiable {
    var id: UUID
     var name: String
     var latitude: Double
     var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

@Model
class WorkItem: Identifiable {
    var id: UUID
    var text: String?
    var mediaURL: URL?
    var mediaType: MediaType
    
    // relationship
    @Relationship(inverse: \TaskItem.inProgressContent)
    var task: TaskItem?
    
    init(
        id: UUID = UUID(),
        text: String? = nil,
        mediaURL: URL? = nil,
        mediaType: MediaType = .text,
        task: TaskItem? = nil
    ) {
        self.id = id
        self.text = text
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.task = task
    }
}



extension TaskItem {
    static var mock: TaskItem {
        // Create a sample location
        let sampleLocation = Location(
            name: "Main Plant - Zone A",
            latitude: 40.9923,
            longitude: 29.1244
        )
        
        // Create a few work items
        let note = WorkItem(
            text: "Control panel installed successfully.",
            mediaType: .text
        )
        
        // Build the task
        return TaskItem(
            id: UUID(),
            title: "Install Control Panel",
            location: sampleLocation,
            deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            assignedUnit: "Electrical Maintenance",
            category: "Installation",
            priority: .high,
            taskDescription: "Install and test the main control panel in Zone A. Ensure all connections are secure and labeled.",
            taskState: .ongoing,
            inProgressContent: [note],
            checklist: [ChecklistItem(title: "Main control panel installed", isChecked: false), ChecklistItem(title: "Connections safe", isChecked: false)],
        )
    }
    
    static var mockData: [TaskItem] {
        let locations = [
            Location(name: "Main Plant - Zone A", latitude: 40.9923, longitude: 29.1244),
            Location(name: "Warehouse B", latitude: 41.0123, longitude: 28.9544),
            Location(name: "Cooling Tower", latitude: 40.9982, longitude: 29.1320),
            Location(name: "Fuel Station", latitude: 41.0221, longitude: 28.9831),
            Location(name: "Security Gate", latitude: 40.9910, longitude: 29.1185)
        ]
        
        let categories = ["Inspection", "Maintenance", "Repair", "Installation", "Upgrade"]
        let units = ["Electrical", "Mechanical", "Instrumentation", "Civil Works", "Operations"]
        let descriptions = [
            "Inspect the designated area and report findings.",
            "Perform maintenance on listed equipment.",
            "Repair or replace defective components.",
            "Install new systems as per the design specs.",
            "Upgrade existing installations to improve efficiency."
        ]
        
        let states: [TaskState] = [.todo, .planned, .ongoing]
        let priorities: [Priority] = [.low, .medium, .high]
        
        return (1...20).map { i in
            let location = locations.randomElement()!
            let category = categories.randomElement()!
            let unit = units.randomElement()!
            let desc = descriptions.randomElement()!
            let state = states.randomElement()!
            let priority = priorities.randomElement()!
            
            let checklist = [
                ChecklistItem(title: "Safety check complete", isChecked: false),
                ChecklistItem(title: "Work permit verified", isChecked: false),
                ChecklistItem(title: "Supervisor notified", isChecked: false)
            ]
            
            let workItems: [WorkItem] = [
            ]
            
            return TaskItem(
                id: UUID(),
                title: "\(category) Task #\(i)",
                location: location,
                deadline: Calendar.current.date(byAdding: .day, value: Int.random(in: 1...14), to: Date())!,
                assignedUnit: unit,
                category: category,
                priority: priority,
                taskDescription: desc,
                taskState: state,
                inProgressContent: workItems,
                checklist: checklist
            )
        }
    }
}

