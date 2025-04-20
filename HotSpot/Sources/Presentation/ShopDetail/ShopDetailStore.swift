import Foundation
import ComposableArchitecture

@Reducer
struct ShopDetailStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        let shop: ShopModel
    }

    enum Action {
        case pop
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .pop:
                return .none
            }
        }
    }
}
