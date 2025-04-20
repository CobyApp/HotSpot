import Foundation

struct ShopSearchResultsDTO: Decodable {
    let resultsAvailable: Int
    let resultsReturned: String
    let resultsStart: Int
    let shop: [ShopDTO]

    enum CodingKeys: String, CodingKey {
        case resultsAvailable = "results_available"
        case resultsReturned = "results_returned"
        case resultsStart = "results_start"
        case shop
    }
}
