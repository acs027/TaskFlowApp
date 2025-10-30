//
//  OfflineSyncMode.swift
//  TaskFlow
//
//  Created by ali cihan on 28.10.2025.
//

import Network

enum OfflineSyncMode: String, CaseIterable, Identifiable {
    case wifiAndCellular = "Wi-Fi or Cellular"
    case wifiOnly = "Wi-Fi Only"
    case off = "Off"
    var id: String { rawValue }
}


extension OfflineSyncMode {
    func types() -> [NWInterface.InterfaceType] {
        switch self {
        case .wifiAndCellular:
            [.cellular, .wifi, .wiredEthernet]
        case .wifiOnly:
            [.wifi, .wiredEthernet]
        case .off:
            []
        }
    }
}
