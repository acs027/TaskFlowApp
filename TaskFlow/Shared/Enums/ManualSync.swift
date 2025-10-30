//
//  ManualSync.swift
//  TaskFlow
//
//  Created by ali cihan on 28.10.2025.
//


enum ManualSync: String, CaseIterable, Identifiable {
    case on = "On"
    case off = "Off"
    var id: String { rawValue }
}