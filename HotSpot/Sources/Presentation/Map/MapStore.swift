import Foundation

import ComposableArchitecture

@Reducer
struct MapStore: Reducer {
    struct State: Equatable {
        var topLeft: Location? = Location(lat: 37.5665, lon: 126.9780)
        var bottomRight: Location? = Location(lat: 37.5665, lon: 126.9780)
        var restaurants: [Restaurant] = [
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
        var selectedRestaurantId: UUID? = nil
    }
    
    enum Action {
        case updateTopLeft(Location?)
        case updateBottomRight(Location?)
        case getRestaurants
        case getRestaurantsResponse(TaskResult<[Restaurant]>)
        case onAppear
        case fetchRestaurants
        case fetchRestaurantsResponse(TaskResult<[Restaurant]>)
        case showSearch
        case showRestaurantDetail(UUID)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateTopLeft(location):
                state.topLeft = location
                return .none
            case let .updateBottomRight(location):
                state.bottomRight = location
                return .none
            case .getRestaurants:
                return .none
            case let .getRestaurantsResponse(.success(restaurants)):
                state.restaurants = restaurants
                return .none
            case let .getRestaurantsResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .onAppear:
                print("MapStore onAppear action received")
                return .none
            case .fetchRestaurants:
                return .none
            case let .fetchRestaurantsResponse(.success(restaurants)):
                state.restaurants = restaurants
                return .none
            case .fetchRestaurantsResponse(.failure):
                return .none
            case .showSearch:
                return .none
            case let .showRestaurantDetail(id):
                state.selectedRestaurantId = id
                return .none
            }
        }
    }
}
