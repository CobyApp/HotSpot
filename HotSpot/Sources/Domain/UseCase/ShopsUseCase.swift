import Foundation

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
            keyword: nil,
            genres: nil,
            order: nil,
            start: nil,
            budget: nil,
            privateRoom: nil,
            wifi: nil,
            nonSmoking: nil,
            coupon: nil,
            openNow: nil
        )
        
        let response = try await repository.searchShops(request: request)
        return response.results.shop.map { $0.toDomain() }
    }
}
