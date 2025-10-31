//
//  UserRole.swift
//  TaskFlow
//
//  Created by ali cihan on 28.10.2025.
//


enum UserRole: String, CaseIterable, Identifiable {
    case admin = "Admin"
    case technician = "Technician"
    case developer = "Developer"
    var id: String { rawValue }
}
