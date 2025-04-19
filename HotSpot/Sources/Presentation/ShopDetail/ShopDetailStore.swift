import Foundation
import ComposableArchitecture

@Reducer
struct ShopDetailStore {
    struct State: Equatable {
        var shopId: String
        var shop: Shop?
        var isLoading: Bool = false
    }
    
    enum Action {
        case onAppear
        case fetchShop
        case fetchShopResponse(TaskResult<Shop>)
        case pop
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.fetchShop)
                }
                
            case .fetchShop:
                state.isLoading = true
                return .run { [id = state.shopId] send in
                    // TODO: 실제 API 호출로 대체
                    try await Task.sleep(nanoseconds: 500_000_000)
                    let shop = Shop(
                        id: id,
                        name: "BBQ치킨 강남점",
                        address: "서울시 강남구 테헤란로 123",
                        imageURL: URL(string: "https://example.com/image1.jpg"),
                        phone: "02-123-4567",
                        location: Location(lat: 37.5665, lon: 126.9780)
                    )
                    await send(.fetchShopResponse(.success(shop)))
                }
                
            case let .fetchShopResponse(.success(shop)):
                state.isLoading = false
                state.shop = shop
                return .none
                
            case .fetchShopResponse(.failure):
                state.isLoading = false
                return .none
                
            case .pop:
                return .none
            }
        }
    }
} 
