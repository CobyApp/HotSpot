import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    struct State: Equatable {
        var search: SearchStore.State = .init()
        var restaurantDetail: RestaurantDetailStore.State?
        var favorite: FavoriteStore.State?
        var settings: SettingsStore.State?
    }

    enum Action {
        case search(SearchStore.Action)
        case restaurantDetail(RestaurantDetailStore.Action)
        case favorite(FavoriteStore.Action)
        case settings(SettingsStore.Action)

        case showRestaurantDetail
        case navigateToFavorite
        case navigateToSettings
        case dismissDetail
        case dismissFavorite
        case dismissSettings
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.search, action: \.search) {
            SearchStore()
        }

        Reduce { state, action in
            switch action {
            case .search(.showRestaurantDetail):
                state.restaurantDetail = .init()
                return .none
                
            case .search(.navigateToSettings):
                state.settings = .init()
                return .none
                
            case .showRestaurantDetail:
                return .none
                
            case .navigateToFavorite:
                state.favorite = .init()
                return .none
                
            case .navigateToSettings:
                state.settings = .init()
                return .none
                
            case .dismissDetail:
                state.restaurantDetail = nil
                return .none
                
            case .dismissFavorite:
                state.favorite = nil
                return .none
                
            case .dismissSettings:
                state.settings = nil
                return .none
                
            case .search:
                return .none
                
            case .restaurantDetail:
                return .none
                
            case .favorite:
                return .none
                
            case .settings:
                return .none
            }
        }
        .ifLet(\.restaurantDetail, action: \.restaurantDetail) {
            RestaurantDetailStore()
        }
        .ifLet(\.favorite, action: \.favorite) {
            FavoriteStore()
        }
        .ifLet(\.settings, action: \.settings) {
            SettingsStore()
        }
    }
}
