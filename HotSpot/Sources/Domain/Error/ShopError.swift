import Foundation

enum ShopError: Error, Equatable {
    case network
    case decoding
    case server(message: String)
    case unknown
}
