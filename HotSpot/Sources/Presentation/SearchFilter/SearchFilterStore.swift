import Foundation
import ComposableArchitecture

@Reducer
struct SearchFilterStore {
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var selectedRange: Range
        var selectedBudgets: [String]
        var selectedGenres: [String]
        var selectedFeatures: Set<String>
        
        init(
            selectedRange: Range = Range(rawValue: UserDefaults.standard.range) ?? .oneKilometer,
            selectedBudgets: [String] = UserDefaults.standard.budgets,
            selectedGenres: [String] = UserDefaults.standard.genres,
            selectedFeatures: Set<String> = []
        ) {
            self.selectedRange = selectedRange
            self.selectedBudgets = selectedBudgets
            self.selectedGenres = selectedGenres
            self.selectedFeatures = selectedFeatures
        }
    }
    
    enum Action: Equatable {
        case updateRange(Range)
        case updateBudgets([String])
        case updateGenres([String])
        case updateFeatures(Set<String>)
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
                
            case let .updateFeatures(features):
                state.selectedFeatures = features
                return .none
                
            case .applyFilters:
                UserDefaults.standard.range = state.selectedRange.rawValue
                UserDefaults.standard.budgets = state.selectedBudgets
                UserDefaults.standard.genres = state.selectedGenres
                UserDefaults.standard.wifi = state.selectedFeatures.contains("Wi-Fiあり") ? 1 : 0
                UserDefaults.standard.privateRoom = state.selectedFeatures.contains("個室あり") ? 1 : 0
                UserDefaults.standard.nonSmoking = state.selectedFeatures.contains("禁煙席あり") ? 1 : 0
                UserDefaults.standard.parking = state.selectedFeatures.contains("駐車場あり") ? 1 : 0
                return .none
                
            case .resetFilters:
                state.selectedRange = .oneKilometer
                state.selectedBudgets = []
                state.selectedGenres = []
                state.selectedFeatures = []
                return .none
            }
        }
    }
}
