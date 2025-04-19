import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    struct State: Equatable {
        var map: MapStore.State = .init()
        var search: SearchStore.State? = nil
        var shopDetail: ShopDetailStore.State?
        var selectedShopId: String?
    }

    enum Action {
        case map(MapStore.Action)
        case search(SearchStore.Action)
        case shopDetail(ShopDetailStore.Action)

        case showShopDetail(String)
        case showSearch
        case dismissSearch
        case dismissDetail
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapStore()
        }
        
        Reduce { state, action in
            switch action {
            case .map(.showSearch), .showSearch:
                state.search = .init()
                return .none
                
            case .search(.pop), .dismissSearch:
                state.search = nil
                return .none
                
            case let .search(.selectShop(shop)):
                state.selectedShopId = shop.id
                return .send(.showShopDetail(shop.id))
                
            case let .showShopDetail(id):
                state.shopDetail = .init(shopId: id)
                return .none
                
            case .shopDetail(.pop), .dismissDetail:
                state.shopDetail = nil
                state.selectedShopId = nil
                return .none
                
            case let .map(.showShopDetail(id)):
                state.selectedShopId = id
                return .send(.showShopDetail(id))
                
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
