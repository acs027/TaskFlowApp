//
//  MapView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI
import MapKit


struct MapView: View {
    @StateObject var locationManager: LocationManager = LocationManager()
    @State var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        
        MapReader { proxy in
            Map(position: $cameraPosition) {
                UserAnnotation()
                
                if let selectedCoordinate {
                    Marker("marker", coordinate: selectedCoordinate)
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    selectedCoordinate = coordinate
                }
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .onChange(of: locationManager.userLocation != nil) { oldValue, newValue in
            if let location = locationManager.userLocation {
                selectedCoordinate = locationManager.userLocation
            }
        }
    }
    
    private func viewOverlay(proxy: MapProxy) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        print(gesture.translation)
                        self.dragOffset = gesture.translation
                        if let region = cameraPosition.region,
                           let currentCenterPoint = proxy.convert(region.center, to: .local) {
                            let newPoint = CGPoint(x: currentCenterPoint.x - dragOffset.width,
                                                   y: currentCenterPoint.y - dragOffset.height)
                            
                            if let newCenter = proxy.convert(newPoint, from: .local) {
                                cameraPosition = .region(
                                    MKCoordinateRegion(
                                        center: newCenter,
                                        span: region.span
                                    )
                                )
                            }
                        }
                    }
                    .onEnded { gesture in
                        // Detect tap if movement was small
                        if abs(gesture.translation.width) < 5 && abs(gesture.translation.height) < 5 {
                            if let coordinate = proxy.convert(gesture.location, from: .local) {
                                selectedCoordinate = coordinate
                            }
                        }
                        dragOffset = .zero
                    }
            )
        //               .allowsHitTesting(isManualMarker)
    }
}
