import Foundation
import Data

public struct InfiniteScrollSearchUseCase {
    private let repository: ShopRepository
    private let pageSize: Int
    
    public init(repository: ShopRepository, pageSize: Int = 20) {
        self.repository = repository
        self.pageSize = pageSize
    }
    
    public func execute(
        latitude: Double,
        longitude: Double,
        range: Int,
        name: String?,
        genres: [String]?,
        budgets: [String]?,
        privateRoom: Int,
        wifi: Int,
        nonSmoking: Int,
        parking: Int,
        currentPage: Int,
        isLoadMore: Bool = false
    ) async throws -> SearchResultModel {
        let targetPage = isLoadMore ? currentPage + 1 : currentPage
        let start = (targetPage - 1) * pageSize + 1
        
        let request = ShopSearchRequestDTO(
            lat: latitude,
            lng: longitude,
            range: range,
            count: pageSize,
            name: name,
            genres: genres,
            start: start,
            budgets: budgets,
            privateRoom: privateRoom,
            wifi: wifi,
            nonSmoking: nonSmoking,
            parking: parking
        )
        
        let response = try await repository.searchShops(request: request)
        return SearchResultModel.from(response: response, currentPage: targetPage)
    }
} 
