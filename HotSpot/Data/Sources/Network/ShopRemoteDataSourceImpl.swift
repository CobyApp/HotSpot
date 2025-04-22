import Foundation
import Moya

final class ShopRemoteDataSourceImpl: ShopRemoteDataSource {
    private let provider: MoyaProvider<ServiceAPI>

    init(provider: MoyaProvider<ServiceAPI> = .default) {
        self.provider = provider
    }

    func search(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO {
        let target = ServiceAPI.searchShops(request)
        let response = try await provider.asyncRequest(target)
        return try JSONDecoder().decode(ShopSearchResponseDTO.self, from: response.data)
    }
}
