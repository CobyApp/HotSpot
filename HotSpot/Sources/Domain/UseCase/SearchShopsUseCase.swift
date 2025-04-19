import Foundation

struct SearchShopsUseCase {
    private let repository: ShopRepository

    init(repository: ShopRepository) {
        self.repository = repository
    }

    func execute(request: ShopSearchRequestDTO) async throws -> [ShopModel] {
        try await repository.searchShops(request: request)
    }
}
