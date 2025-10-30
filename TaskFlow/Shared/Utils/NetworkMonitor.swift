//
//  NetworkMonitor.swift
//  TaskFlow
//
//  Created by ali cihan on 30.10.2025.
//

import Foundation
import Network
import Combine
import SwiftUI

extension EnvironmentValues {
    @Entry var isNetworkConnected: Bool?
    @Entry var connectionType: NWInterface.InterfaceType?
}

@MainActor
final class NetworkMonitor: ObservableObject {
    
    @Published var isConnected: Bool = true
    @Published private(set) var connectionType: NWInterface.InterfaceType?
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                self.connectionType = path.availableInterfaces
                    .first(where: { path.usesInterfaceType($0.type) })?
                    .type
            }
        }
        monitor.start(queue: queue)
    }
}
