import Foundation

struct ShopSearchResponseDTO: Decodable {
    let results: ShopSearchResultsDTO

    enum CodingKeys: String, CodingKey {
        case results
    }
}
