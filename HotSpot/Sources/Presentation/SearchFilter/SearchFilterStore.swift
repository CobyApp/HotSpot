import Foundation
import ComposableArchitecture

@Reducer
struct SearchFilterStore {
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var selectedRange: Int
        var selectedBudget: String
        var selectedGenreCode: String
        var hasWiFi: Bool
        var hasPrivateRoom: Bool
        var isNonSmoking: Bool
        
        init(
            selectedRange: Int = UserDefaults.standard.range,
            selectedBudget: String = UserDefaults.standard.budget,
            selectedGenreCode: String = UserDefaults.standard.genre,
            hasWiFi: Bool = UserDefaults.standard.wifi,
            hasPrivateRoom: Bool = UserDefaults.standard.privateRoom,
            isNonSmoking: Bool = UserDefaults.standard.nonSmoking
        ) {
            self.selectedRange = selectedRange
            self.selectedBudget = selectedBudget
            self.selectedGenreCode = selectedGenreCode
            self.hasWiFi = hasWiFi
            self.hasPrivateRoom = hasPrivateRoom
            self.isNonSmoking = isNonSmoking
        }
    }
    
    enum Action: Equatable {
        case updateRange(Int)
        case updateBudget(String)
        case updateGenre(String)
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
                
            case let .updateBudget(budget):
                state.selectedBudget = budget
                UserDefaults.standard.budget = budget
                return .none
                
            case let .updateGenre(genre):
                state.selectedGenreCode = genre
                UserDefaults.standard.genre = genre
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
