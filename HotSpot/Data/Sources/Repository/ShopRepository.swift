import Foundation

public protocol ShopRepository {
    func searchShops(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO
}
