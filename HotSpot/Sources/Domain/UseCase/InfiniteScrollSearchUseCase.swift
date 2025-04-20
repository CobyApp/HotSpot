import Foundation

struct InfiniteScrollSearchUseCase {
    private let repository: ShopRepository
    private let pageSize: Int
    
    init(repository: ShopRepository, pageSize: Int = 20) {
        self.repository = repository
        self.pageSize = pageSize
    }
    
    func execute(
        request: ShopSearchRequestDTO,
        currentPage: Int,
        isLoadMore: Bool = false
    ) async throws -> SearchResultModel {
        let targetPage = isLoadMore ? currentPage + 1 : currentPage
        let start = (targetPage - 1) * pageSize + 1
        
        let paginatedRequest = ShopSearchRequestDTO(
            lat: request.lat,
            lng: request.lng,
            range: request.range,
            count: pageSize,
            keyword: request.keyword,
            genre: request.genre,
            order: request.order,
            start: start,
            budget: request.budget,
            privateRoom: request.privateRoom,
            wifi: request.wifi,
            nonSmoking: request.nonSmoking,
            coupon: request.coupon,
            openNow: request.openNow
        )
        
        let response = try await repository.searchShops(request: paginatedRequest)
        return SearchResultModel.from(response: response, currentPage: targetPage)
    }
} 