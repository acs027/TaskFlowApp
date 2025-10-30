
import SwiftUI
import MapKit

struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
    
    var name: String { mapItem.name ?? "Unknown" }
    var placemark: MKPlacemark { mapItem.placemark }
    var coordinate: CLLocationCoordinate2D { placemark.coordinate }
    var titleText: String { placemark.title ?? "" }
}

struct MapSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var searchText = ""
    @State private var searchResults: [IdentifiableMapItem] = []
    @StateObject private var locationManager = LocationManager()
    @State private var address: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            SheetControlButtons()
            coordinatesLabel
            
            TappableMapView(region: $region, selectedCoordinate: $selectedCoordinate)
                .frame(height: 300)
                .cornerRadius(10)
                .padding(.horizontal)
            
            userLocationButton
            
            HStack {
                TextField("Search for a place...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                Button("Search") { searchPlaces() }
                    .padding()
                    .glassEffect(.regular.interactive())
            }
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            searchResultsLabel
            Spacer()
        }
        .padding()
        .onAppear {
            locationManager.requestPermission()
        }
        .onChange(of: CoordinateWrapper(coordinate: selectedCoordinate)) { _, _ in
            if let coordinate = selectedCoordinate {
                getAddress(from: coordinate)
            }
        }
    }
    
    @ViewBuilder
    private var searchResultsLabel: some View {
        if !searchResults.isEmpty {
            List(searchResults) { item in
                Button {
                    selectedCoordinate = item.coordinate
                    region.center = item.coordinate
                } label: {
                    VStack(alignment: .leading) {
                        Text(item.name).bold()
                        Text(item.titleText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var coordinatesLabel: some View {
        HStack{
            VStack(alignment: .leading ,spacing: 4) {
                Text("📍 Latitude: \(selectedCoordinate?.latitude ?? 0)")
                Text("📍 Longitude: \(selectedCoordinate?.longitude ?? 0)")
                Text("📬 \(address)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            Spacer()
        }
    }
    
    private var userLocationButton: some View {
        Button {
            requestUserLocation()
        } label: {
            Label("Use My Location", systemImage: "location.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
        .padding()
    }
    
    private func searchPlaces() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }
            searchResults = response.mapItems.map { IdentifiableMapItem(mapItem: $0) }
        }
    }
    
    private func requestUserLocation() {
        if locationManager.userLocation != nil,
           let location = locationManager.userLocation {
            self.selectedCoordinate = location
            self.region.center = location
        }
    }
    
    private func getAddress(from coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                var addressString = ""
                if let name = placemark.name { addressString += name }
                if let locality = placemark.locality { addressString += ", \(locality)" }
                if let country = placemark.country { addressString += ", \(country)" }
                DispatchQueue.main.async {
                    self.address = addressString
                }
            } else {
                DispatchQueue.main.async {
                    self.address = "Address not found"
                }
            }
        }
    }
}

struct CoordinateWrapper: Equatable {
    let coordinate: CLLocationCoordinate2D?
    static func == (lhs: CoordinateWrapper, rhs: CoordinateWrapper) -> Bool {
        lhs.coordinate?.latitude == rhs.coordinate?.latitude &&
        lhs.coordinate?.longitude == rhs.coordinate?.longitude
    }
}

#Preview {
    MapSearchView(
        selectedCoordinate: .constant(
            CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530)
        )
    )
}



