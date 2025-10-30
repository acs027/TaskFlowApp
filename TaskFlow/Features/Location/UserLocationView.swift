//
//  UserLocationView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import SwiftUI
import CoreLocation

struct UserLocationView: View {
    @State var viewModel = UserLocationViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Current Coordinates") {
                    if viewModel.locationManager.userLocation != nil {
                        HStack {
                            Text("Latitude :")
                                .bold()
                            Text("\(viewModel.locationManager.userLocation?.latitude ?? 0)")
                        }
                        HStack {
                            Text("Longitude :")
                                .bold()
                            Text("\(viewModel.locationManager.userLocation?.longitude ?? 0)")
                        }
                    } else {
                        Text("Location not available")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("System Status") {
                    HStack {
                        Text("Permission :")
                            .bold()
                        Spacer()
                        Text("\(viewModel.locationManager.authStatus())")
                    }
                    
                    HStack {
                        Text("Service : ")
                            .bold()
                        Spacer()
                        Text(viewModel.locationManager.isServiceActive ? "On" : "Off")
                    }
                    
                }
            }
            .navigationTitle("My Location")
        }
    }
}

#Preview {
    UserLocationView()
}



