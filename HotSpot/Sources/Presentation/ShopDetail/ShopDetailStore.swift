import Foundation
import ComposableArchitecture

@Reducer
struct ShopDetailStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        var shop: ShopModel
        var isLoading: Bool = false
        var error: String? = nil
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case pop
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                return .none

            case .pop:
                return .none
            }
        }
    }
} 
