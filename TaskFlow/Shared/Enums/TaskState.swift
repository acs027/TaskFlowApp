//
//  TaskState.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation
import SwiftUI

enum TaskState: String, Codable, CaseIterable, Identifiable, Comparable {
    case planned = "Planned"
    case todo = "To do"
    case ongoing = "Ongoing"
    case review = "Review"
    case completed = "Completed"

    var id: String { rawValue }
    
    var nextStep: Self {
        switch self {
        case .planned:
                .todo
        case .todo:
                .ongoing
        case .ongoing:
                .review
        case .review:
                .completed
        case .completed:
                .completed
        }
    }
    
    static func < (lhs: TaskState, rhs: TaskState) -> Bool {
         let order: [TaskState] = [.planned, .todo, .ongoing, .review, .completed]
         return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
     }
}
