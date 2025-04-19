import Foundation
import ComposableArchitecture

@Reducer
struct MapStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        var shops: [ShopModel] = []
        var selectedShopId: String? = nil
        var centerLat: Double = 35.6762  // Default to Tokyo
        var centerLng: Double = 139.6503
        var isInitialized: Bool = false
        var error: String? = nil
        var currentRange: Int = 3  // Default to 1km
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case fetchShops
        case showSearch
        case showShopDetail(String)
        case updateCoordinates(lat: Double, lng: Double)
        case updateShops([ShopModel])
        case handleError(Error)
        case updateRange(Int)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                return .run { send in
                    await send(.fetchShops)
                }

            case let .updateCoordinates(lat, lng):
                state.centerLat = lat
                state.centerLng = lng
                return .run { send in
                    await send(.fetchShops)
                }

            case let .updateRange(range):
                state.currentRange = range
                return .run { send in
                    await send(.fetchShops)
                }

            case .fetchShops:
                return .run { [state] send in
                    do {
                        let request = ShopSearchRequestDTO(
                            lat: state.centerLat,
                            lng: state.centerLng,
                            range: state.currentRange,
                            count: 100,
                            keyword: nil,
                            genre: nil,
                            order: nil,
                            start: nil,
                            budget: nil,
                            privateRoom: nil,
                            wifi: nil,
                            nonSmoking: nil,
                            coupon: nil,
                            openNow: nil
                        )
                        let shops = try await shopRepository.searchShops(request: request)
                        await send(.updateShops(shops))
                    } catch {
                        await send(.handleError(error))
                    }
                }

            case let .updateShops(shops):
                state.shops = shops
                return .none

            case let .handleError(error):
                state.error = error.localizedDescription
                return .none

            case .showSearch:
                return .none

            case let .showShopDetail(id):
                state.selectedShopId = id
                return .none
            }
        }
    }
}
