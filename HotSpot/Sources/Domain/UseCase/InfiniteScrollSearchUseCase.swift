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
        currentPage: Int
    ) async throws -> SearchResultModel {
        let paginatedRequest = ShopSearchRequestDTO(
            lat: request.lat,
            lng: request.lng,
            range: request.range,
            count: pageSize,
            keyword: request.keyword,
            genre: request.genre,
            order: request.order,
            start: (currentPage - 1) * pageSize + 1,
            budget: request.budget,
            privateRoom: request.privateRoom,
            wifi: request.wifi,
            nonSmoking: request.nonSmoking,
            coupon: request.coupon,
            openNow: request.openNow,
            page: currentPage,
            pageSize: pageSize
        )
        
        let response = try await repository.searchShops(request: paginatedRequest)
        return SearchResultModel.from(response: response, currentPage: currentPage)
    }
    
    func loadMore(
        request: ShopSearchRequestDTO,
        currentPage: Int
    ) async throws -> SearchResultModel {
        try await execute(request: request, currentPage: currentPage + 1)
    }
} 