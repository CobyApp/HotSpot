import Foundation

final class ShopRepositoryImpl: ShopRepository {
    private let remoteDataSource: ShopRemoteDataSource

    init(remoteDataSource: ShopRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func searchShops(lat: Double, lng: Double, range: Int, count: Int) async throws -> [ShopModel] {
        let requestDTO = ShopSearchRequestDTO(lat: lat, lng: lng, range: range, count: count)
        let response = try await remoteDataSource.search(request: requestDTO)
        return response.results.shop.map { $0.toDomain() }
    }
}
