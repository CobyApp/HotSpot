import Foundation

public struct ShopSearchResultsDTO: Decodable {
    public let resultsAvailable: Int
    public let resultsReturned: String
    public let resultsStart: Int
    public let shop: [ShopDTO]

    public enum CodingKeys: String, CodingKey {
        case resultsAvailable = "results_available"
        case resultsReturned = "results_returned"
        case resultsStart = "results_start"
        case shop
    }
}
