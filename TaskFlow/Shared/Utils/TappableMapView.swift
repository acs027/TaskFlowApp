//
//  TappableMapView.swift
//  TaskFlow
//
//  Created by ali cihan on 28.10.2025.
//
import SwiftUI
import MapKit
struct TappableMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: TappableMapView

        init(parent: TappableMapView) {
            self.parent = parent
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let mapView = gesture.view as! MKMapView
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            parent.selectedCoordinate = coordinate
            parent.updateAnnotation(on: mapView, coordinate: coordinate)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tap)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        if let coordinate = selectedCoordinate {
            updateAnnotation(on: mapView, coordinate: coordinate)
        }
    }

    func updateAnnotation(on mapView: MKMapView, coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
