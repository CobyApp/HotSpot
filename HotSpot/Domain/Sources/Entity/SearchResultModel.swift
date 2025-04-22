import Foundation

struct SearchResultModel {
    let shops: [ShopModel]
    let currentPage: Int
    let hasMore: Bool
    let totalCount: Int
    
    init(shops: [ShopModel], currentPage: Int, hasMore: Bool, totalCount: Int) {
        self.shops = shops
        self.currentPage = currentPage
        self.hasMore = hasMore
        self.totalCount = totalCount
    }
    
    static func from(response: ShopSearchResponseDTO, currentPage: Int) -> SearchResultModel {
        let shops = response.results.shop.map { $0.toDomain() }
        let resultsReturned = Int(response.results.resultsReturned) ?? 1
        let currentEnd = response.results.resultsStart + resultsReturned
        let hasMore = currentEnd < response.results.resultsAvailable
        
        return SearchResultModel(
            shops: shops,
            currentPage: currentPage,
            hasMore: hasMore,
            totalCount: response.results.resultsAvailable
        )
    }
} 