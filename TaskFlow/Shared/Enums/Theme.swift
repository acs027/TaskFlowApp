//
//  Theme.swift
//  TaskFlow
//
//  Created by ali cihan on 28.10.2025.
//


enum Theme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    var id: String { rawValue }
}