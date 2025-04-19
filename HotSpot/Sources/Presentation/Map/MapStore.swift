import Foundation
import ComposableArchitecture

@Reducer
struct MapStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        var shops: [ShopModel] = []
        var selectedShopId: String? = nil
        var centerLat: Double = 35.6762  // Default to Tokyo coordinates
        var centerLng: Double = 139.6503
    }

    enum Action {
        case onAppear
        case mapDidMove(lat: Double, lng: Double)
        case fetchShops
        case fetchShopsResponse(TaskResult<[ShopModel]>)
        case showSearch
        case showShopDetail(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchShops)

            case let .mapDidMove(lat, lng):
                state.centerLat = lat
                state.centerLng = lng
                return .send(.fetchShops)

            case .fetchShops:
                print("🔍 Fetching shops for coordinates: lat=\(state.centerLat), lng=\(state.centerLng)")
                return .run { [centerLat = state.centerLat, centerLng = state.centerLng] send in
                    await send(
                        .fetchShopsResponse(
                            TaskResult {
                                let shops = try await shopRepository.searchShops(
                                    lat: centerLat,
                                    lng: centerLng,
                                    range: 3,
                                    count: 100
                                )
                                print("✅ Successfully fetched \(shops.count) shops")
                                return shops
                            }
                        )
                    )
                }

            case let .fetchShopsResponse(.success(shops)):
                state.shops = shops
                print("📊 Updated shops count: \(shops.count)")
                return .none

            case .fetchShopsResponse(.failure(let error)):
                print("❌ Failed to fetch shops: \(error)")
                // TODO: 에러 처리 로직 추가 가능
                return .none

            case .showSearch:
                // TODO: 검색 화면 이동 트리거
                return .none

            case let .showShopDetail(id):
                state.selectedShopId = id
                return .none
            }
        }
    }
}
