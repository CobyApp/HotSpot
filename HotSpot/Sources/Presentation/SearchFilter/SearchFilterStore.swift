import Foundation
import ComposableArchitecture

@Reducer
struct SearchFilterStore {
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var selectedRange: Int
        var selectedBudgets: [String]
        var selectedGenres: [String]
        var hasWiFi: Bool
        var hasPrivateRoom: Bool
        var isNonSmoking: Bool
        
        init(
            selectedRange: Int = UserDefaults.standard.range,
            selectedBudgets: [String] = UserDefaults.standard.budgets,
            selectedGenres: [String] = UserDefaults.standard.genres,
            hasWiFi: Bool = UserDefaults.standard.wifi,
            hasPrivateRoom: Bool = UserDefaults.standard.privateRoom,
            isNonSmoking: Bool = UserDefaults.standard.nonSmoking
        ) {
            self.selectedRange = selectedRange
            self.selectedBudgets = selectedBudgets
            self.selectedGenres = selectedGenres
            self.hasWiFi = hasWiFi
            self.hasPrivateRoom = hasPrivateRoom
            self.isNonSmoking = isNonSmoking
        }
    }
    
    enum Action: Equatable {
        case updateRange(Int)
        case updateBudgets([String])
        case updateGenres([String])
        case updateWiFi(Bool)
        case updatePrivateRoom(Bool)
        case updateNonSmoking(Bool)
        case resetFilters
    }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateRange(range):
                state.selectedRange = range
                UserDefaults.standard.range = range
                return .none
                
            case let .updateBudgets(budgets):
                state.selectedBudgets = budgets
                UserDefaults.standard.budgets = budgets
                return .none
                
            case let .updateGenres(genres):
                state.selectedGenres = genres
                UserDefaults.standard.genres = genres
                return .none
                
            case let .updateWiFi(hasWiFi):
                state.hasWiFi = hasWiFi
                UserDefaults.standard.wifi = hasWiFi
                return .none
                
            case let .updatePrivateRoom(hasPrivateRoom):
                state.hasPrivateRoom = hasPrivateRoom
                UserDefaults.standard.privateRoom = hasPrivateRoom
                return .none
                
            case let .updateNonSmoking(isNonSmoking):
                state.isNonSmoking = isNonSmoking
                UserDefaults.standard.nonSmoking = isNonSmoking
                return .none
                
            case .resetFilters:
                state = State()
                return .none
            }
        }
    }
}
