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
        case navigateToSettings
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showRestaurantDetail:
                return .none
            case let .updateRange(range):
                state.selectedRange = range
                return .none
            case .navigateToSettings:
                return .none
            }
        }
    }
} 