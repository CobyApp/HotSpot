import Foundation
import CoreLocation
import MapKit

struct MapCoordinate: Equatable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapRegion: Equatable {
    let center: MapCoordinate
    let span: MapSpan
    
    init(center: MapCoordinate, span: MapSpan) {
        self.center = center
        self.span = span
    }
    
    init(region: MKCoordinateRegion) {
        self.center = MapCoordinate(coordinate: region.center)
        self.span = MapSpan(span: region.span)
    }
    
    var mkCoordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: center.clLocationCoordinate2D,
            span: span.mkCoordinateSpan
        )
    }
}

struct MapSpan: Equatable {
    let latitudeDelta: Double
    let longitudeDelta: Double
    
    init(latitudeDelta: Double, longitudeDelta: Double) {
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    init(span: MKCoordinateSpan) {
        self.latitudeDelta = span.latitudeDelta
        self.longitudeDelta = span.longitudeDelta
    }
    
    var mkCoordinateSpan: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
} 