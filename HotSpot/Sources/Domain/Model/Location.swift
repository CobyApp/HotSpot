import Foundation
import MapKit

struct Location: Codable, Hashable {
    var lat: Double
    var lon: Double
}

extension Location {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: self.lat,
            longitude: self.lon
        )
    }
}

extension CLLocationCoordinate2D {
    func toLocation() -> Location {
        Location(
            lat: self.latitude,
            lon: self.longitude
        )
    }
}
