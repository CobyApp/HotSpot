import Foundation

struct ShopSearchRequestDTO {
    let lat: Double                   // Latitude
    let lng: Double                   // Longitude
    let range: Int                    // Search range (1–5)
    let count: Int?                   // Number of results (1–100)
    let keyword: String?             // Keyword search
    let genres: [String]?            // Genre codes
    let start: Int?                  // Starting index for paging
    let budgets: [String]?           // Budget codes
    let privateRoom: Int             // Private room availability (0 or 1)
    let wifi: Int                    // Wi-Fi availability (0 or 1)
    let nonSmoking: Int              // Non-smoking availability (0 or 1)
    let parking: Int                 // Parking availability (0 or 1)

    /// Converts the DTO into a dictionary of parameters for Moya or URL encoding
    var asParameters: [String: Any] {
        var params: [String: Any] = [
            "lat": lat,
            "lng": lng,
            "range": range,
            "private_room": privateRoom,
            "wifi": wifi,
            "non_smoking": nonSmoking,
            "parking": parking
        ]

        if let count = count { params["count"] = count }
        if let keyword = keyword { params["keyword"] = keyword }
        if let genres = genres, !genres.isEmpty { params["genre"] = genres.joined(separator: ",") }
        if let start = start { params["start"] = start }
        if let budgets = budgets, !budgets.isEmpty { params["budget"] = budgets.joined(separator: ",") }

        return params
    }
}
