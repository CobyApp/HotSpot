import Foundation

public final class ShopRepositoryImpl: ShopRepository {
    private let remoteDataSource: ShopRemoteDataSource

    public init(remoteDataSource: ShopRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func searchShops(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO {
        try await remoteDataSource.search(request: request)
    }
}
