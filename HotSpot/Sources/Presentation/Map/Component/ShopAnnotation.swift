import MapKit

class ShopAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var shopId: String
    var genreCode: String

    init(coordinate: CLLocationCoordinate2D, title: String?, shopId: String, genreCode: String) {
        self.coordinate = coordinate
        self.title = title
        self.shopId = shopId
        self.genreCode = genreCode
    }
} 