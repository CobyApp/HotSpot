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
        let response = try await repository.searchShops(request: request)
        return SearchResultModel.from(response: response, currentPage: currentPage)
    }
    
    func loadMore(
        request: ShopSearchRequestDTO,
        currentPage: Int
    ) async throws -> SearchResultModel {
        try await execute(request: request, currentPage: currentPage + 1)
    }
} 