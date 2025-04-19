import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    struct State: Equatable {
        var map: MapStore.State = .init()
        var search: SearchStore.State? = nil
        var restaurantDetail: RestaurantDetailStore.State?
        var selectedRestaurantId: UUID?
    }

    enum Action {
        case map(MapStore.Action)
        case search(SearchStore.Action)
        case restaurantDetail(RestaurantDetailStore.Action)

        case showRestaurantDetail(UUID)
        case showSearch
        case dismissSearch
        case dismissDetail
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .map(.showSearch), .showSearch:
                state.search = .init()
                return .none
                
            case .search(.pop), .dismissSearch:
                state.search = nil
                return .none
                
            case let .search(.selectRestaurant(restaurant)):
                state.selectedRestaurantId = restaurant.id
                return .send(.showRestaurantDetail(restaurant.id))
                
            case let .showRestaurantDetail(id):
                state.restaurantDetail = .init(restaurantId: id)
                return .none
                
            case .restaurantDetail(.pop), .dismissDetail:
                state.restaurantDetail = nil
                state.selectedRestaurantId = nil
                return .none
                
            case let .map(.showRestaurantDetail(id)):
                state.selectedRestaurantId = id
                return .send(.showRestaurantDetail(id))
                
            case .map, .search, .restaurantDetail:
                return .none
            }
        }
    }
}
