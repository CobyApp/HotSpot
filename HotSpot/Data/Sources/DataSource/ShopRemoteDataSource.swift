import Foundation

public protocol ShopRemoteDataSource {
    func search(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO
}
