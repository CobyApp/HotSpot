import Foundation

public struct ShopSearchResponseDTO: Decodable {
    public let results: ShopSearchResultsDTO
    
    public enum CodingKeys: String, CodingKey {
        case results
    }
}
