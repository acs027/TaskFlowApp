//
//  OfflineSyncMode.swift
//  TaskFlow
//
//  Created by ali cihan on 28.10.2025.
//


enum OfflineSyncMode: String, CaseIterable, Identifiable {
    case wifiAndCellular = "Wi-Fi or Cellular"
    case wifiOnly = "Wi-Fi Only"
    case off = "Off"
    var id: String { rawValue }
}