import Foundation

public struct ShopModel: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    public let imageUrl: String
    public let access: String
    public let openingHours: String
    public let genre: Genre
    public let budget: Budget
    public let url: String
    public let wifi: Int
    public let privateRoom: Int
    public let nonSmoking: Int
    public let parking: Int
    
    public var coordinate: MapCoordinate {
        MapCoordinate(latitude: latitude, longitude: longitude)
    }
    
    public static func filterVisibleShops(_ shops: [ShopModel], in region: MapRegion) -> [ShopModel] {
        shops.filter { shop in
            let latMin = region.center.latitude - region.span.latitudeDelta / 2
            let latMax = region.center.latitude + region.span.latitudeDelta / 2
            let lonMin = region.center.longitude - region.span.longitudeDelta / 2
            let lonMax = region.center.longitude + region.span.longitudeDelta / 2

            return shop.latitude >= latMin &&
                   shop.latitude <= latMax &&
                   shop.longitude >= lonMin &&
                   shop.longitude <= lonMax
        }
    }
    
    public init(
        id: String,
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        imageUrl: String,
        access: String,
        openingHours: String,
        genre: Genre,
        budget: Budget,
        url: String,
        wifi: Int,
        privateRoom: Int,
        nonSmoking: Int,
        parking: Int
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.imageUrl = imageUrl
        self.access = access
        self.openingHours = openingHours
        self.genre = genre
        self.budget = budget
        self.url = url
        self.wifi = wifi
        self.privateRoom = privateRoom
        self.nonSmoking = nonSmoking
        self.parking = parking
    }
}
