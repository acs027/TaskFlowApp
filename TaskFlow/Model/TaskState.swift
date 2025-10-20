//
//  TaskState.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation

enum TaskState: String, Codable, CaseIterable, Identifiable {
    case initial
    case planning
    case workInProgress
    case control
    case done

    var id: String { rawValue }
}
