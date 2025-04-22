import Foundation
import Data

public protocol ShopRepository {
    func searchShops(request: ShopSearchRequestDTO) async throws -> ShopSearchResponseDTO
}
