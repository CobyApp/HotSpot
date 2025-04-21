import Foundation
import ComposableArchitecture

@Reducer
struct SearchFilterStore {
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var selectedDistance: Int
        var selectedBudget: Int
        var hasPrivateRoom: Bool
        var hasWiFi: Bool
        var isNonSmoking: Bool
        var selectedGenreCode: String
        
        init(
            selectedDistance: Int = 0,
            selectedBudget: Int = 0,
            hasPrivateRoom: Bool = false,
            hasWiFi: Bool = false,
            isNonSmoking: Bool = false,
            selectedGenreCode: String = ""
        ) {
            self.selectedDistance = selectedDistance
            self.selectedBudget = selectedBudget
            self.hasPrivateRoom = hasPrivateRoom
            self.hasWiFi = hasWiFi
            self.isNonSmoking = isNonSmoking
            self.selectedGenreCode = selectedGenreCode
        }
    }
    
    enum Action: Equatable {
        case updateDistance(Int)
        case updateBudget(Int)
        case updatePrivateRoom(Bool)
        case updateWiFi(Bool)
        case updateNonSmoking(Bool)
        case updateGenre(String)
        case resetFilters
    }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateDistance(distance):
                state.selectedDistance = distance
                userDefaults.distance = distance
                return .none
                
            case let .updateBudget(budget):
                state.selectedBudget = budget
                userDefaults.budget = budget
                return .none
                
            case let .updatePrivateRoom(hasPrivateRoom):
                state.hasPrivateRoom = hasPrivateRoom
                userDefaults.privateRoom = hasPrivateRoom
                return .none
                
            case let .updateWiFi(hasWiFi):
                state.hasWiFi = hasWiFi
                userDefaults.wifi = hasWiFi
                return .none
                
            case let .updateNonSmoking(isNonSmoking):
                state.isNonSmoking = isNonSmoking
                userDefaults.nonSmoking = isNonSmoking
                return .none
                
            case let .updateGenre(genreCode):
                state.selectedGenreCode = genreCode
                userDefaults.genre = genreCode
                return .none
                
            case .resetFilters:
                state = State(
                    selectedDistance: userDefaults.distance,
                    selectedBudget: userDefaults.budget,
                    hasPrivateRoom: userDefaults.privateRoom,
                    hasWiFi: userDefaults.wifi,
                    isNonSmoking: userDefaults.nonSmoking,
                    selectedGenreCode: userDefaults.genre
                )
                return .none
            }
        }
    }
}
