import Foundation

struct ShopModel: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String
    let access: String
    let openingHours: String
    let genre: Genre
    let budget: Budget
    let url: String
    let wifi: Int
    let privateRoom: Int
    let nonSmoking: Int
    let parking: Int
    
    var coordinate: MapCoordinate {
        MapCoordinate(latitude: latitude, longitude: longitude)
    }
    
    static func filterVisibleShops(_ shops: [ShopModel], in region: MapRegion) -> [ShopModel] {
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
}
