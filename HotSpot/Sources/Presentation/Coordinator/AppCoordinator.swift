import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    struct State: Equatable {
        var map: MapStore.State = .init()
        var search: SearchStore.State? = nil
        var restaurantDetail: RestaurantDetailStore.State?
        var favorite: FavoriteStore.State?
        var settings: SettingsStore.State?
        var selectedRestaurantId: UUID?
    }

    enum Action {
        case map(MapStore.Action)
        case search(SearchStore.Action)
        case restaurantDetail(RestaurantDetailStore.Action)
        case favorite(FavoriteStore.Action)
        case settings(SettingsStore.Action)

        case showRestaurantDetail(UUID)
        case navigateToFavorite
        case navigateToSettings
        case showSearch
        case dismissSearch
        case dismissDetail
        case dismissFavorite
        case dismissSettings
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
                
            case .navigateToFavorite:
                state.favorite = .init()
                return .none
                
            case .navigateToSettings:
                state.settings = .init()
                return .none
                
            case .dismissDetail:
                state.restaurantDetail = nil
                state.selectedRestaurantId = nil
                return .none
                
            case .dismissFavorite:
                state.favorite = nil
                return .none
                
            case .dismissSettings:
                state.settings = nil
                return .none
                
            case .map, .search, .restaurantDetail, .favorite, .settings:
                return .none
            }
        }
    }
}
