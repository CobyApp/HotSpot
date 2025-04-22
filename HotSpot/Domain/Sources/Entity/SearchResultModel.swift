import Foundation
import Data

public struct SearchResultModel {
    public let shops: [ShopModel]
    public let currentPage: Int
    public let hasMore: Bool
    public let totalCount: Int
    
    public init(shops: [ShopModel], currentPage: Int, hasMore: Bool, totalCount: Int) {
        self.shops = shops
        self.currentPage = currentPage
        self.hasMore = hasMore
        self.totalCount = totalCount
    }
    
    public static func from(response: ShopSearchResponseDTO, currentPage: Int) -> SearchResultModel {
        let shops = response.results.shop.map { $0.toShopModel() }
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
