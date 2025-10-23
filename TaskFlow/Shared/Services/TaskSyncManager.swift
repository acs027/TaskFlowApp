//
//  TaskSyncManager.swift
//  TaskFlow
//
//  Created by ali cihan on 23.10.2025.
//

import Foundation
import FirebaseFirestore
import SwiftData

@MainActor
final class TaskSyncManager {
    private let db = Firestore.firestore()
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func syncLocalToFirebase() async {
        let fetchDescriptor = FetchDescriptor<TaskItem>()
        guard let tasks = try? context.fetch(fetchDescriptor) else { return }
        
        for task in tasks {
            await uploadTaskIfNeeded(task)
        }
    }
    
    private func uploadTaskIfNeeded(_ task: TaskItem) async {
        let docRef = db.collection("tasks").document(task.id.uuidString)
        
        // Convert nested arrays to serializable dictionaries
        let checklistData = task.checklist.map { [
            "id": $0.id.uuidString,
            "title": $0.title,
            "isChecked": $0.isChecked
        ]}

        let workData = task.ongoingContent.map { [
            "id": $0.id.uuidString,
            "text": $0.text ?? "",
            "mediaURL": $0.mediaURL?.absoluteString ?? "",
            "mediaType": $0.mediaType.rawValue
        ]}
        
        let data: [String: Any] = [
            "id": task.id.uuidString,
            "title": task.title,
            "deadline": Timestamp(date: task.deadline),
            "assignedUnit": task.assignedUnit,
            "category": task.category ?? "",
            "priority": task.priority?.rawValue ?? "",
            "taskDescription": task.taskDescription ?? "",
            "taskState": task.taskState.rawValue,
            "location": [
                "name": task.location.name,
                "latitude": task.location.latitude,
                "longitude": task.location.longitude
            ],
            "checklist": checklistData,
            "workItems": workData
        ]
        
        try? await docRef.setData(data, merge: true)
    }
    
    func syncFirebaseToLocal() async {
        guard let snapshot = try? await db.collection("tasks").getDocuments() else { return }

        for doc in snapshot.documents {
            guard let title = doc["title"] as? String,
                  let assignedUnit = doc["assignedUnit"] as? String,
                  let deadline = (doc["deadline"] as? Timestamp)?.dateValue(),
                  let stateRaw = doc["taskState"] as? String,
                  let taskState = TaskState(rawValue: stateRaw)
            else { continue }
            
            let id = UUID(uuidString: doc.documentID) ?? UUID()
            
            // Location
            let locationDict = doc["location"] as? [String: Any]
            let location = Location(
                name: locationDict?["name"] as? String ?? "",
                latitude: locationDict?["latitude"] as? Double ?? 0,
                longitude: locationDict?["longitude"] as? Double ?? 0
            )
            
            // Checklist
            var checklistItems: [ChecklistItem] = []
            if let checklistArray = doc["checklist"] as? [[String: Any]] {
                checklistItems = checklistArray.map {
                    ChecklistItem(
                        title: $0["title"] as? String ?? "",
                        isChecked: $0["isChecked"] as? Bool ?? false
                    )
                }
            }

            // Work Items
            var workItems: [WorkItem] = []
            if let workArray = doc["workItems"] as? [[String: Any]] {
                workItems = workArray.map {
                    WorkItem(
                        text: $0["text"] as? String,
                        mediaURL: URL(string: $0["mediaURL"] as? String ?? ""),
                        mediaType: MediaType(rawValue: $0["mediaType"] as? String ?? "text") ?? .text
                    )
                }
            }

            let existing = try? context.fetch(
                FetchDescriptor<TaskItem>(predicate: #Predicate { $0.id == id })
            ).first
            
            if let existing {
                existing.title = title
                existing.assignedUnit = assignedUnit
                existing.deadline = deadline
                existing.taskState = taskState
                existing.category = doc["category"] as? String
                existing.priority = Priority(rawValue: doc["priority"] as? String ?? "")
                existing.taskDescription = doc["taskDescription"] as? String ?? ""
                existing.checklist = checklistItems
                existing.ongoingContent = workItems
            } else {
                let newTask = TaskItem(
                    id: id,
                    title: title,
                    location: location,
                    deadline: deadline,
                    assignedUnit: assignedUnit,
                    category: doc["category"] as? String,
                    priority: Priority(rawValue: doc["priority"] as? String ?? ""),
                    taskDescription: doc["taskDescription"] as? String ?? "",
                    taskState: taskState,
                    workInProgress: workItems,
                    checklist: checklistItems
                )
                context.insert(newTask)
            }
        }
        
        try? context.save()
    }


    
//    func syncFirebaseToLocal() async {
//        let snapshot = try? await db.collection("tasks").getDocuments()
//        guard let documents = snapshot?.documents else { return }
//        
//        for doc in documents {
//            guard let title = doc["title"] as? String,
//                  let assignedUnit = doc["assignedUnit"] as? String,
//                  let deadline = (doc["deadline"] as? Timestamp)?.dateValue(),
//                  let stateRaw = doc["taskState"] as? String,
//                  let taskState = TaskState(rawValue: stateRaw)
//            else { continue }
//            
//            // Check if already exists locally
//            let id = UUID(uuidString: doc.documentID)!
//            if let existing = try? context.fetch(FetchDescriptor<TaskItem>(predicate: #Predicate { $0.id == id })).first {
//                // update
//                existing.title = title
//                existing.assignedUnit = assignedUnit
//                existing.deadline = deadline
//                existing.taskState = taskState
//            } else {
//                // create new
//                let locationDict = doc["location"] as? [String: Any]
//                let location = Location(
//                    name: locationDict?["name"] as? String ?? "",
//                    latitude: locationDict?["latitude"] as? Double ?? 0,
//                    longitude: locationDict?["longitude"] as? Double ?? 0
//                )
//                let task = TaskItem(
//                    id: id,
//                    title: title,
//                    location: location,
//                    deadline: deadline,
//                    assignedUnit: assignedUnit,
//                    taskState: taskState,
//                    todoList: ""
//                )
//                context.insert(task)
//            }
//        }
//        
//        try? context.save()
//    }
}
