import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    struct State: Equatable {
        var map: MapStore.State = .init()
        var search: SearchStore.State?
        var shopDetail: ShopDetailStore.State?
    }

    enum Action {
        case map(MapStore.Action)
        case search(SearchStore.Action)
        case shopDetail(ShopDetailStore.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapStore()
        }
        
        Reduce { state, action in
            switch action {
            case let .map(.showSearch):
                state.search = .init()
                return .none
                
            case let .map(.showShopDetail(shop)):
                state.shopDetail = .init(shop: shop)
                return .none
                
            case let .search(.showShopDetail(shop)):
                state.shopDetail = .init(shop: shop)
                return .none
                
            case .search(.pop):
                state.search = nil
                return .none
                
            case .shopDetail(.pop):
                state.shopDetail = nil
                return .none
                
            case .map, .search, .shopDetail:
                return .none
            }
        }
        .ifLet(\.search, action: \.search) {
            SearchStore()
        }
        .ifLet(\.shopDetail, action: \.shopDetail) {
            ShopDetailStore()
        }
    }
}
