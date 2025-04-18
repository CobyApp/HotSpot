import Foundation
import ComposableArchitecture

@Reducer
struct FavoriteStore {
    @ObservableState
    struct State: Equatable {
        // Empty state for now
    }
    
    enum Action {
        case showRestaurantDetail
        case pop
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showRestaurantDetail:
                return .none
            case .pop:
                return .none
            }
        }
    }
} 