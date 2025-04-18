import Foundation
import ComposableArchitecture

@Reducer
struct SearchStore {
    @ObservableState
    struct State: Equatable {
        var selectedRange: Int = 1
    }
    
    enum Action {
        case showRestaurantDetail
        case updateRange(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showRestaurantDetail:
                return .none
            case .updateRange(let range):
                state.selectedRange = range
                return .none
            }
        }
    }
} 