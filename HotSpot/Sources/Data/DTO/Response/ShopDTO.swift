import Foundation

struct ShopDTO: Decodable {
    let id: String
    let name: String
    let address: String
    let lat: Double
    let lng: Double
    let access: String
    let open: String?
    let photo: Photo

    struct Photo: Decodable {
        let mobile: Mobile

        struct Mobile: Decodable {
            let large: String

            enum CodingKeys: String, CodingKey {
                case large = "l"
            }
        }
    }

    func toDomain() -> ShopModel {
        ShopModel(
            id: id,
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            imageUrl: photo.mobile.large,
            access: access,
            openingHours: open
        )
    }
}
