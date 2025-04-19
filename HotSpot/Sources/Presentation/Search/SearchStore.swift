import Foundation
import CoreLocation

import ComposableArchitecture

@Reducer
struct SearchStore {
    struct State: Equatable {
        var searchText: String = ""
        var shops: [Shop] = []
        var isLoading: Bool = false
        var currentPage: Int = 1
        var hasMorePages: Bool = true
    }
    
    enum Action {
        case searchTextChanged(String)
        case search
        case searchResponse(TaskResult<[Shop]>)
        case loadMore
        case selectShop(Shop)
        case pop
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                return .none
                
            case .search:
                guard !state.searchText.isEmpty else { return .none }
                
                state.isLoading = true
                state.currentPage = 1
                state.shops = []
                state.hasMorePages = true
                
                return .run { [text = state.searchText] send in
                    try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
                    let shops = generateDummyShops(for: text)
                    await send(.searchResponse(.success(shops)))
                }
                
            case let .searchResponse(.success(shops)):
                state.isLoading = false
                state.shops = shops
                return .none
                
            case .searchResponse(.failure):
                state.isLoading = false
                return .none
                
            case .loadMore:
                return .none
                
            case let .selectShop(shop):
                return .none
                
            case .pop:
                return .none
            }
        }
    }
    
    private func generateDummyShops(for query: String, page: Int = 1) -> [Shop] {
        // Always return some results for testing
        let shops = [
            Shop(
                id: "1",
                name: "BBQ치킨 강남점",
                address: "서울시 강남구 테헤란로 123",
                imageURL: URL(string: "https://example.com/image1.jpg"),
                phone: "02-123-4567",
                location: Location(lat: 37.5665, lon: 126.9780)
            ),
            Shop(
                id: "2",
                name: "BHC치킨 홍대점",
                address: "서울시 마포구 홍대입구로 123",
                imageURL: URL(string: "https://example.com/image2.jpg"),
                phone: "02-234-5678",
                location: Location(lat: 37.5665, lon: 126.9780)
            ),
            Shop(
                id: "3",
                name: "교촌치킨 이태원점",
                address: "서울시 용산구 이태원로 123",
                imageURL: URL(string: "https://example.com/image3.jpg"),
                phone: "02-345-6789",
                location: Location(lat: 37.5665, lon: 126.9780)
            )
        ]
        
        return shops
    }
} 
