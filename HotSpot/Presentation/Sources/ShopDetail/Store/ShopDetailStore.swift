import Foundation
import ComposableArchitecture
import Domain

struct ShopDetailStore: Reducer {
    struct State: Equatable {
        let shop: ShopModel
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
