import Foundation
import ComposableArchitecture

@Reducer
struct SearchFilterStore {
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var selectedRange: Int
        var selectedBudgets: [String]
        var selectedGenres: [String]
        var wifi: Int
        var privateRoom: Int
        var nonSmoking: Int
        var parking: Int
        
        init(
            selectedRange: Int = UserDefaults.standard.range,
            selectedBudgets: [String] = UserDefaults.standard.budgets,
            selectedGenres: [String] = UserDefaults.standard.genres,
            wifi: Int = UserDefaults.standard.wifi,
            privateRoom: Int = UserDefaults.standard.privateRoom,
            nonSmoking: Int = UserDefaults.standard.nonSmoking,
            parking: Int = UserDefaults.standard.parking
        ) {
            self.selectedRange = selectedRange
            self.selectedBudgets = selectedBudgets
            self.selectedGenres = selectedGenres
            self.wifi = wifi
            self.privateRoom = privateRoom
            self.nonSmoking = nonSmoking
            self.parking = parking
        }
    }
    
    enum Action: Equatable {
        case updateRange(Int)
        case updateBudgets([String])
        case updateGenres([String])
        case updateWiFi(Int)
        case updatePrivateRoom(Int)
        case updateNonSmoking(Int)
        case updateParking(Int)
        case applyFilters
        case resetFilters
    }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateRange(range):
                state.selectedRange = range
                return .none
                
            case let .updateBudgets(budgets):
                state.selectedBudgets = budgets
                return .none
                
            case let .updateGenres(genres):
                state.selectedGenres = genres
                return .none
                
            case let .updateWiFi(wifi):
                state.wifi = wifi
                return .none
                
            case let .updatePrivateRoom(privateRoom):
                state.privateRoom = privateRoom
                return .none
                
            case let .updateNonSmoking(nonSmoking):
                state.nonSmoking = nonSmoking
                return .none
                
            case let .updateParking(parking):
                state.parking = parking
                return .none
                
            case .applyFilters:
                UserDefaults.standard.range = state.selectedRange
                UserDefaults.standard.budgets = state.selectedBudgets
                UserDefaults.standard.genres = state.selectedGenres
                UserDefaults.standard.wifi = state.wifi
                UserDefaults.standard.privateRoom = state.privateRoom
                UserDefaults.standard.nonSmoking = state.nonSmoking
                UserDefaults.standard.parking = state.parking
                return .none
                
            case .resetFilters:
                state.selectedRange = 3
                state.selectedBudgets = []
                state.selectedGenres = []
                state.wifi = 0
                state.privateRoom = 0
                state.nonSmoking = 0
                state.parking = 0
                return .none
            }
        }
    }
}
