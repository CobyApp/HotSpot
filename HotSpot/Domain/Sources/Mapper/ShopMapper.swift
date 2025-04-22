import Foundation
import Data

extension ShopDTO.Genre {
    func toGenre() -> Genre? {
        return Genre(rawValue: code)
    }
}

extension ShopDTO.Budget {
    func toBudget() -> Budget? {
        return Budget(rawValue: code)
    }
}

extension ShopDTO {
    func toShopModel() -> ShopModel {
        ShopModel(
            id: id,
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            imageUrl: photo.pc.large,
            access: access,
            openingHours: open ?? "営業時間情報なし",
            genre: genre.toGenre() ?? .other,
            budget: budget?.toBudget() ?? .from1501to2000,
            url: urls.pc,
            wifi: wifi == "あり" ? 1 : 0,
            privateRoom: privateRoom == "あり" ? 1 : 0,
            nonSmoking: nonSmoking == "あり" ? 1 : 0,
            parking: parking == "あり" ? 1 : 0
        )
    }
} 
