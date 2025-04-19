import MapKit

extension MKCoordinateRegion {
    var northEast: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: center.latitude + span.latitudeDelta / 2,
            longitude: center.longitude + span.longitudeDelta / 2
        )
    }
    
    var southWest: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: center.latitude - span.latitudeDelta / 2,
            longitude: center.longitude - span.longitudeDelta / 2
        )
    }
    
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        coordinate.latitude <= northEast.latitude &&
        coordinate.latitude >= southWest.latitude &&
        coordinate.longitude <= northEast.longitude &&
        coordinate.longitude >= southWest.longitude
    }
}
