import Foundation

protocol ShopRemoteDataSource {
    func search(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO
}
