import Foundation
import CoreLocation
import MapKit

public struct MapCoordinate: Equatable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    public var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

public struct MapRegion: Equatable {
    public let center: MapCoordinate
    public let span: MapSpan
    
    public init(center: MapCoordinate, span: MapSpan) {
        self.center = center
        self.span = span
    }
    
    public init(region: MKCoordinateRegion) {
        self.center = MapCoordinate(coordinate: region.center)
        self.span = MapSpan(span: region.span)
    }
    
    public var mkCoordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: center.clLocationCoordinate2D,
            span: span.mkCoordinateSpan
        )
    }
}

public struct MapSpan: Equatable {
    public let latitudeDelta: Double
    public let longitudeDelta: Double
    
    public init(latitudeDelta: Double, longitudeDelta: Double) {
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    public init(span: MKCoordinateSpan) {
        self.latitudeDelta = span.latitudeDelta
        self.longitudeDelta = span.longitudeDelta
    }
    
    public var mkCoordinateSpan: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
} 