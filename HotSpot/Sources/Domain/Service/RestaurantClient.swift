import Foundation
import ComposableArchitecture
import Dependencies

struct ShopClient: DependencyKey {
    static var liveValue: ShopClient = .live
    
    var searchShops: @Sendable (_ latitude: Double, _ longitude: Double, _ radius: Int) async throws -> [Shop]
    
    static let live = Self(
        searchShops: { latitude, longitude, radius in
            // TODO: Implement actual API call
            // For now, return mock data
            return [
                Shop(
                    name: "맛있는 식당",
                    address: "서울시 강남구 테헤란로 123",
                    imageURL: URL(string: "https://example.com/image1.jpg"),
                    phone: "02-123-4567",
                    location: Location(lat: latitude, lon: longitude)
                ),
                Shop(
                    name: "맛있는 카페",
                    address: "서울시 강남구 테헤란로 456",
                    imageURL: URL(string: "https://example.com/image2.jpg"),
                    phone: "02-765-4321",
                    location: Location(lat: latitude + 0.001, lon: longitude + 0.001)
                )
            ]
        }
    )
}

extension DependencyValues {
    var shopClient: ShopClient {
        get { self[ShopClient.self] }
        set { self[ShopClient.self] = newValue }
    }
} 
