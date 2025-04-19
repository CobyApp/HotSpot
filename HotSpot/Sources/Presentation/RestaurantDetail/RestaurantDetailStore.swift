import Foundation
import ComposableArchitecture

@Reducer
struct RestaurantDetailStore {
    struct State: Equatable {
        var restaurantId: UUID
        var restaurant: Restaurant?
        var isLoading: Bool = false
    }
    
    enum Action {
        case onAppear
        case fetchRestaurant
        case fetchRestaurantResponse(TaskResult<Restaurant>)
        case pop
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.fetchRestaurant)
                }
                
            case .fetchRestaurant:
                state.isLoading = true
                return .run { [id = state.restaurantId] send in
                    // TODO: 실제 API 호출로 대체
                    try await Task.sleep(nanoseconds: 500_000_000)
                    let restaurant = Restaurant(
                        id: id,
                        name: "BBQ치킨 강남점",
                        address: "서울시 강남구 테헤란로 123",
                        imageURL: URL(string: "https://example.com/image1.jpg"),
                        phone: "02-123-4567",
                        location: Location(lat: 37.5665, lon: 126.9780)
                    )
                    await send(.fetchRestaurantResponse(.success(restaurant)))
                }
                
            case let .fetchRestaurantResponse(.success(restaurant)):
                state.isLoading = false
                state.restaurant = restaurant
                return .none
                
            case .fetchRestaurantResponse(.failure):
                state.isLoading = false
                return .none
                
            case .pop:
                return .none
            }
        }
    }
} 