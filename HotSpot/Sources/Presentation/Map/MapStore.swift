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
                print("🗺️ Map appeared, initializing...")
                if !state.isInitialized {
                    state.isInitialized = true
                    return .send(.fetchShops)
                }
                return .none

            case let .mapDidMove(lat, lng):
                print("📍 Map moved to: lat=\(lat), lng=\(lng)")
                state.centerLat = lat
                state.centerLng = lng
                return .send(.fetchShops)

            case .fetchShops:
                print("🔍 Fetching shops with parameters:")
                print("  - Center: lat=\(state.centerLat), lng=\(state.centerLng)")
                print("  - Range: 3")
                print("  - Count: 100")
                
                return .run { [centerLat = state.centerLat, centerLng = state.centerLng] send in
                    do {
                        print("📡 Making API request...")
                        let shops = try await shopRepository.searchShops(
                            lat: centerLat,
                            lng: centerLng,
                            range: 3,
                            count: 100
                        )
                        print("✅ API request successful")
                        print("📊 Received \(shops.count) shops")
                        await send(.fetchShopsResponse(.success(shops)))
                    } catch {
                        print("❌ API request failed: \(error)")
                        print("Error details: \(error.localizedDescription)")
                        await send(.fetchShopsResponse(.failure(error)))
                    }
                }

            case let .fetchShopsResponse(.success(shops)):
                print("📦 Updating state with \(shops.count) shops")
                state.shops = shops
                return .none

            case let .fetchShopsResponse(.failure(error)):
                print("⚠️ Failed to update shops: \(error)")
                print("Error details: \(error.localizedDescription)")
                return .none

            case .showSearch:
                print("🔎 Showing search view")
                return .none

            case let .showShopDetail(id):
                print("🏪 Showing shop detail for ID: \(id)")
                state.selectedShopId = id
                return .none
            }
        }
    }
}
