import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    struct State: Equatable {
        var map: MapStore.State = .init()
        var search: SearchStore.State?
        var shopDetail: ShopDetailStore.State?
        var selectedShop: ShopModel?
        var isDetailPresented: Bool = false
    }

    enum Action {
        case map(MapStore.Action)
        case search(SearchStore.Action)
        case shopDetail(ShopDetailStore.Action)

        case showShopDetail(ShopModel)
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
                state.selectedShop = shop
                state.isDetailPresented = true
                return .send(.showShopDetail(shop))
                
            case let .showShopDetail(shop):
                state.shopDetail = .init(shop: shop)
                state.isDetailPresented = true
                return .none
                
            case .shopDetail(.pop):
                state.shopDetail = nil
                state.selectedShop = nil
                state.isDetailPresented = false
                return .none
                
            case .dismissDetail:
                state.shopDetail = nil
                state.selectedShop = nil
                state.isDetailPresented = false
                return .none
                
            case let .map(.showShopDetail(shop)):
                state.selectedShop = shop
                state.isDetailPresented = true
                return .send(.showShopDetail(shop))
                
            case .map:
                return .none
                
            case .search:
                return .none
                
            case .shopDetail:
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
