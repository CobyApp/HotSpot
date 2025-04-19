import Foundation

protocol ShopRepository {
    func searchShops(request: ShopSearchRequestDTO) async throws -> [ShopModel]
}
