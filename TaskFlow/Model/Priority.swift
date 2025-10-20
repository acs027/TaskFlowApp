//
//  Priority.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import Foundation

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }

    var colorName: String {
        switch self {
        case .low: return "Green"
        case .medium: return "Orange"
        case .high: return "Red"
        }
    }
}
