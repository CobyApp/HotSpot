import Foundation

final class ShopRepositoryImpl: ShopRepository {
    private let remoteDataSource: ShopRemoteDataSource

    init(remoteDataSource: ShopRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func searchShops(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO {
        try await remoteDataSource.search(request: request)
    }
}
