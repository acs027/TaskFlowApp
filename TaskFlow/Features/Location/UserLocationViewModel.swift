//
//  UserLocationViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import Foundation

@Observable
class UserLocationViewModel {
    var locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
    }
}
