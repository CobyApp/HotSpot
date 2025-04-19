import Foundation

import ComposableArchitecture

@Reducer
struct MapStore: Reducer {
    struct State: Equatable {
        var topLeft: Location? = nil
        var bottomRight: Location? = nil
        var restaurants: [Restaurant] = []
        var filteredRestaurants: [Restaurant] = []
    }
    
    enum Action {
        case updateTopLeft(Location?)
        case updateBottomRight(Location?)
        case getRestaurants
        case getRestaurantsResponse(TaskResult<[Restaurant]>)
        case filterRestaurant
        case onAppear
        case fetchRestaurants
        case fetchRestaurantsResponse(TaskResult<[Restaurant]>)
        case showSearch
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateTopLeft(location):
                state.topLeft = location
                return .send(.filterRestaurant)
            case let .updateBottomRight(location):
                state.bottomRight = location
                return .send(.filterRestaurant)
            case .getRestaurants:
                return .none
            case let .getRestaurantsResponse(.success(restaurants)):
                state.restaurants = restaurants
                return .send(.filterRestaurant)
            case let .getRestaurantsResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .filterRestaurant:
                guard let topLeft = state.topLeft else { return .none }
                guard let bottomRight = state.bottomRight else { return .none }
                state.filteredRestaurants = state.restaurants.filter { restaurant in
                    guard let location = restaurant.location else { return false }
                    return location.lat <= topLeft.lat &&
                    location.lat >= bottomRight.lat &&
                    location.lon >= topLeft.lon &&
                    location.lon <= bottomRight.lon
                }
                return .none
            case .onAppear:
                return .send(.fetchRestaurants)
            case .fetchRestaurants:
                return .none
//                return .run { send in
//                    await send(
//                        .fetchRestaurantsResponse(
//                            await TaskResult {
//                                try await restaurantClient.fetchRestaurants()
//                            }
//                        )
//                    )
//                }
            case let .fetchRestaurantsResponse(.success(restaurants)):
                state.restaurants = restaurants
                return .none
            case .fetchRestaurantsResponse(.failure):
                return .none
            case .showSearch:
                return .none
            }
        }
    }
}
