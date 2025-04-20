import Foundation

protocol SearchRepository {
    func searchShops(request: ShopSearchRequestDTO, currentPage: Int) async throws -> SearchResultModel
} 