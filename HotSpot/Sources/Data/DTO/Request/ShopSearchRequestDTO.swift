import Foundation

struct ShopSearchRequestDTO {
    let lat: Double                   // Latitude
    let lng: Double                   // Longitude
    let range: Int                    // Search range (1–5)
    let count: Int                    // Number of results (1–100)
    let keyword: String?             // Keyword search
    let genre: String?               // Genre code
    let order: Int?                  // Order: 1=recommend, 2=popularity
    let start: Int?                  // Starting index for paging
    let budget: String?              // Budget code
    let privateRoom: Bool?           // Private room availability
    let wifi: Bool?                  // Wi-Fi availability
    let nonSmoking: Bool?            // Non-smoking availability
    let coupon: Bool?                // Coupon availability
    let openNow: Bool?               // Currently open filter

    /// Converts the DTO into a dictionary of parameters for Moya or URL encoding
    var asParameters: [String: Any] {
        var params: [String: Any] = [
            "lat": lat,
            "lng": lng,
            "range": range,
            "count": count
        ]

        if let keyword = keyword { params["keyword"] = keyword }
        if let genre = genre { params["genre"] = genre }
        if let order = order { params["order"] = order }
        if let start = start { params["start"] = start }
        if let budget = budget { params["budget"] = budget }
        if let privateRoom = privateRoom { params["private_room"] = privateRoom ? 1 : 0 }
        if let wifi = wifi { params["wifi"] = wifi ? 1 : 0 }
        if let nonSmoking = nonSmoking { params["non_smoking"] = nonSmoking ? 1 : 0 }
        if let coupon = coupon { params["coupon"] = coupon ? 1 : 0 }
        if let openNow = openNow, openNow { params["open"] = "now" }

        return params
    }
}
