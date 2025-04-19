import Foundation

struct ShopModel: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String
    let access: String
    let openingHours: String?
    let genreCode: String
}
