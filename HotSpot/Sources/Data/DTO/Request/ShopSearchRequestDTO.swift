import Foundation
import CoreLocation

struct ShopSearchRequestDTO {
    let lat: Double
    let lng: Double
    let range: Int
    let count: Int

    var asParameters: [String: Any] {
        return [
            "lat": lat,
            "lng": lng,
            "range": range,
            "count": count
        ]
    }
}
