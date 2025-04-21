import Foundation
import ComposableArchitecture

@Reducer
struct SearchFilterStore {
    private enum UserDefaultsKey {
        static let budget = "shop_filter_budget"
        static let hasWiFi = "shop_filter_has_wifi"
        static let hasPrivateRoom = "shop_filter_has_private_room"
        static let isNonSmoking = "shop_filter_is_non_smoking"
        static let hasParking = "shop_filter_has_parking"
        static let cuisine = "shop_filter_cuisine"
        static let distance = "shop_filter_distance"
    }
    
    struct State: Equatable {
        var selectedBudget: Int
        var hasWiFi: Bool
        var hasPrivateRoom: Bool
        var isNonSmoking: Bool
        var hasParking: Bool
        var selectedCuisine: Int
        var selectedDistance: Int
        
        init() {
            let defaults = UserDefaults.standard
            self.selectedBudget = defaults.integer(forKey: UserDefaultsKey.budget)
            self.hasWiFi = defaults.bool(forKey: UserDefaultsKey.hasWiFi)
            self.hasPrivateRoom = defaults.bool(forKey: UserDefaultsKey.hasPrivateRoom)
            self.isNonSmoking = defaults.bool(forKey: UserDefaultsKey.isNonSmoking)
            self.hasParking = defaults.bool(forKey: UserDefaultsKey.hasParking)
            self.selectedCuisine = defaults.integer(forKey: UserDefaultsKey.cuisine)
            self.selectedDistance = defaults.integer(forKey: UserDefaultsKey.distance)
        }
    }
    
    enum Action {
        case updateBudget(Int)
        case toggleWiFi
        case togglePrivateRoom
        case toggleNonSmoking
        case toggleParking
        case updateCuisine(Int)
        case updateDistance(Int)
        case resetFilters
        case applyFilters
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateBudget(budget):
                state.selectedBudget = budget
                UserDefaults.standard.set(budget, forKey: UserDefaultsKey.budget)
                return .none
                
            case .toggleWiFi:
                state.hasWiFi.toggle()
                UserDefaults.standard.set(state.hasWiFi, forKey: UserDefaultsKey.hasWiFi)
                return .none
                
            case .togglePrivateRoom:
                state.hasPrivateRoom.toggle()
                UserDefaults.standard.set(state.hasPrivateRoom, forKey: UserDefaultsKey.hasPrivateRoom)
                return .none
                
            case .toggleNonSmoking:
                state.isNonSmoking.toggle()
                UserDefaults.standard.set(state.isNonSmoking, forKey: UserDefaultsKey.isNonSmoking)
                return .none
                
            case .toggleParking:
                state.hasParking.toggle()
                UserDefaults.standard.set(state.hasParking, forKey: UserDefaultsKey.hasParking)
                return .none
                
            case let .updateCuisine(cuisine):
                state.selectedCuisine = cuisine
                UserDefaults.standard.set(cuisine, forKey: UserDefaultsKey.cuisine)
                return .none
                
            case let .updateDistance(distance):
                state.selectedDistance = distance
                UserDefaults.standard.set(distance, forKey: UserDefaultsKey.distance)
                return .none
                
            case .resetFilters:
                state.selectedBudget = 0
                state.hasWiFi = false
                state.hasPrivateRoom = false
                state.isNonSmoking = false
                state.hasParking = false
                state.selectedCuisine = 0
                state.selectedDistance = 3
                
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.budget)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.hasWiFi)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.hasPrivateRoom)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.isNonSmoking)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.hasParking)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.cuisine)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.distance)
                
                return .none
                
            case .applyFilters:
                return .none
            }
        }
    }
}
