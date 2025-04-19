import Foundation
import ComposableArchitecture

@Reducer
struct MapStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        var shops: [ShopModel] = []
        var selectedShopId: String? = nil
    }

    enum Action {
        case onAppear
        case mapDidMove
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

            case .mapDidMove:
                return .send(.fetchShops)

            case .fetchShops:
                // 서울 시청 좌표
                let centerLat = 37.5665
                let centerLng = 126.9780

                return .run { send in
                    await send(
                        .fetchShopsResponse(
                            TaskResult {
                                try await shopRepository.searchShops(
                                    lat: centerLat,
                                    lng: centerLng,
                                    range: 3,
                                    count: 100
                                )
                            }
                        )
                    )
                }

            case let .fetchShopsResponse(.success(shops)):
                state.shops = shops
                return .none

            case .fetchShopsResponse(.failure):
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
