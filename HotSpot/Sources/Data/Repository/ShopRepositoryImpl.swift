import Foundation

final class ShopRepositoryImpl: ShopRepository {
    private let remoteDataSource: ShopRemoteDataSource

    init(remoteDataSource: ShopRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func searchShops(request: ShopSearchRequestDTO) async throws -> [ShopModel] {
        let response = try await remoteDataSource.search(request: request)
        return response.results.shop.map { $0.toDomain() }
    }
}
