import Foundation
import CoreLocation

import ComposableArchitecture

@Reducer
struct SearchStore {
    struct State: Equatable {
        var searchText: String = ""
        var restaurants: [Restaurant] = []
        var isLoading: Bool = false
        var currentPage: Int = 1
        var hasMorePages: Bool = true
    }
    
    enum Action {
        case searchTextChanged(String)
        case search
        case searchResponse(TaskResult<[Restaurant]>)
        case loadMore
        case selectRestaurant(Restaurant)
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
                state.restaurants = []
                state.hasMorePages = true
                
                return .run { [text = state.searchText] send in
                    try await Task.sleep(nanoseconds: 500_000_000) // Simulate network delay
                    let restaurants = generateDummyRestaurants(for: text)
                    await send(.searchResponse(.success(restaurants)))
                }
                
            case let .searchResponse(.success(restaurants)):
                state.isLoading = false
                state.restaurants = restaurants
                return .none
                
            case .searchResponse(.failure):
                state.isLoading = false
                return .none
                
            case .loadMore:
                return .none
                
            case let .selectRestaurant(restaurant):
                return .none
                
            case .pop:
                return .none
            }
        }
    }
    
    private func generateDummyRestaurants(for query: String, page: Int = 1) -> [Restaurant] {
        // Always return some results for testing
        let restaurants = [
            Restaurant(
                id: UUID(),
                name: "BBQ치킨 강남점",
                address: "서울시 강남구 테헤란로 123",
                imageURL: URL(string: "https://example.com/image1.jpg"),
                phone: "02-123-4567",
                location: Location(lat: 37.5665, lon: 126.9780)
            ),
            Restaurant(
                id: UUID(),
                name: "BHC치킨 홍대점",
                address: "서울시 마포구 홍대입구로 123",
                imageURL: URL(string: "https://example.com/image2.jpg"),
                phone: "02-234-5678",
                location: Location(lat: 37.5665, lon: 126.9780)
            ),
            Restaurant(
                id: UUID(),
                name: "교촌치킨 이태원점",
                address: "서울시 용산구 이태원로 123",
                imageURL: URL(string: "https://example.com/image3.jpg"),
                phone: "02-345-6789",
                location: Location(lat: 37.5665, lon: 126.9780)
            )
        ]
        
        return restaurants
    }
} 
