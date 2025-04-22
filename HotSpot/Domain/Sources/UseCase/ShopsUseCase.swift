import Foundation
import Data

struct ShopsUseCase {
    private let repository: ShopRepository

    init(repository: ShopRepository) {
        self.repository = repository
    }

    func execute(lat: Double, lng: Double) async throws -> [ShopModel] {
        let request = ShopSearchRequestDTO(
            lat: lat,
            lng: lng,
            range: 5,
            count: nil,
            name: nil,
            genres: nil,
            start: nil,
            budgets: nil,
            privateRoom: 0,
            wifi: 0,
            nonSmoking: 0,
            parking: 0
        )
        
        let response = try await repository.searchShops(request: request)
        return response.results.shop.map { $0.toShopModel() }
    }
}
