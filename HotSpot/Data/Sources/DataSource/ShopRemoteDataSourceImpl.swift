import Foundation
import Moya
import Shared

public final class ShopRemoteDataSourceImpl: ShopRemoteDataSource {
    private let provider: MoyaProvider<ServiceAPI>

    public init(provider: MoyaProvider<ServiceAPI> = .default) {
        self.provider = provider
    }

    public func search(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO {
        let target = ServiceAPI.searchShops(request)
        let response = try await provider.asyncRequest(target)
        return try JSONDecoder().decode(ShopSearchResponseDTO.self, from: response.data)
    }
}
