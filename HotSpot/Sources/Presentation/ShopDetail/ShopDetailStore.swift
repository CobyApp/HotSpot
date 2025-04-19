import Foundation
import ComposableArchitecture

@Reducer
struct ShopDetailStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        let shop: ShopModel
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case pop
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .pop:
                return .none
            }
        }
    }
} 
