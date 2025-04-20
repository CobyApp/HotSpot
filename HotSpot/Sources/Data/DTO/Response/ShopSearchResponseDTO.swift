import Foundation

struct ShopSearchResponseDTO: Decodable {
    let results: ShopSearchResultsDTO
    
    var hasMore: Bool {
        let currentEnd = results.resultsStart + (Int(results.resultsReturned) ?? 0)
        return currentEnd < results.resultsAvailable
    }
    
    var currentPage: Int {
        (results.resultsStart - 1) / (Int(results.resultsReturned) ?? 1) + 1
    }
    
    var totalPages: Int {
        let pageSize = Int(results.resultsReturned) ?? 1
        return Int(ceil(Double(results.resultsAvailable) / Double(pageSize)))
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
