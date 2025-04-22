import Foundation

public struct ShopSearchRequestDTO {
    public let lat: Double                   // Latitude
    public let lng: Double                   // Longitude
    public let range: Int                    // Search range (1–5)
    public let count: Int?                   // Number of results (1–100)
    public let name: String?                 // Name search
    public let genres: [String]?            // Genre codes
    public let start: Int?                  // Starting index for paging
    public let budgets: [String]?           // Budget codes
    public let privateRoom: Int             // Private room availability (0 or 1)
    public let wifi: Int                    // Wi-Fi availability (0 or 1)
    public let nonSmoking: Int              // Non-smoking availability (0 or 1)
    public let parking: Int                 // Parking availability (0 or 1)

    public init(
        lat: Double,
        lng: Double,
        range: Int,
        count: Int? = nil,
        name: String? = nil,
        genres: [String]? = nil,
        start: Int? = nil,
        budgets: [String]? = nil,
        privateRoom: Int,
        wifi: Int,
        nonSmoking: Int,
        parking: Int
    ) {
        self.lat = lat
        self.lng = lng
        self.range = range
        self.count = count
        self.name = name
        self.genres = genres
        self.start = start
        self.budgets = budgets
        self.privateRoom = privateRoom
        self.wifi = wifi
        self.nonSmoking = nonSmoking
        self.parking = parking
    }

    /// Converts the DTO into a dictionary of parameters for Moya or URL encoding
    public var asParameters: [String: Any] {
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
        if let name = name { params["name"] = name }
        if let genres = genres, !genres.isEmpty { params["genre"] = genres.joined(separator: ",") }
        if let start = start { params["start"] = start }
        if let budgets = budgets, !budgets.isEmpty { params["budget"] = budgets.joined(separator: ",") }

        return params
    }
}
