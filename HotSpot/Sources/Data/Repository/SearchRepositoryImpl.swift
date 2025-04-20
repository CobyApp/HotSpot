import Foundation

final class SearchRepositoryImpl: SearchRepository {
    private let remoteDataSource: ShopRemoteDataSource
    
    init(remoteDataSource: ShopRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func searchShops(request: ShopSearchRequestDTO, currentPage: Int) async throws -> SearchResultModel {
        let useCase = InfiniteScrollSearchUseCase(repository: ShopRepositoryImpl(remoteDataSource: remoteDataSource))
        return try await useCase.execute(request: request, currentPage: currentPage)
    }
} 