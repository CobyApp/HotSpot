import Foundation
import ComposableArchitecture

@Reducer
struct SettingsStore {
    @ObservableState
    struct State: Equatable {
        var defaultSearchRange: Int = 1
    }
    
    enum Action {
        case updateSearchRange(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateSearchRange(range):
                state.defaultSearchRange = range
                return .none
            }
        }
    }
} 