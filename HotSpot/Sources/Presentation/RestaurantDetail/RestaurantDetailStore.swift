import Foundation
import ComposableArchitecture

@Reducer
struct RestaurantDetailStore {
    @ObservableState
    struct State: Equatable {
        var isFavorite: Bool = false
    }
    
    enum Action {
        case toggleFavorite
        case navigateToSettings
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleFavorite:
                state.isFavorite.toggle()
                return .none
                
            case .navigateToSettings:
                return .none
            }
        }
    }
} 