import Foundation
import ComposableArchitecture

private enum UserDefaultsKey: DependencyKey {
    static let liveValue = UserDefaults.standard
}

extension DependencyValues {
    var userDefaults: UserDefaults {
        get { self[UserDefaultsKey.self] }
        set { self[UserDefaultsKey.self] = newValue }
    }
}

// MARK: - Filter Keys
extension UserDefaults {
    private enum FilterKey: String {
        case range = "range"
        case budgets = "budgets"
        case genres = "genres"
        case wifi = "wifi"
        case privateRoom = "privateRoom"
        case nonSmoking = "nonSmoking"
        case parking = "parking"
    }
    
    var range: Int {
        get { integer(forKey: FilterKey.range.rawValue) }
        set { set(newValue, forKey: FilterKey.range.rawValue) }
    }
    
    var budgets: [String] {
        get { stringArray(forKey: FilterKey.budgets.rawValue) ?? [] }
        set { set(newValue, forKey: FilterKey.budgets.rawValue) }
    }
    
    var genres: [String] {
        get { stringArray(forKey: FilterKey.genres.rawValue) ?? [] }
        set { set(newValue, forKey: FilterKey.genres.rawValue) }
    }
    
    var wifi: Bool {
        get { bool(forKey: FilterKey.wifi.rawValue) }
        set { set(newValue, forKey: FilterKey.wifi.rawValue) }
    }
    
    var privateRoom: Bool {
        get { bool(forKey: FilterKey.privateRoom.rawValue) }
        set { set(newValue, forKey: FilterKey.privateRoom.rawValue) }
    }
    
    var nonSmoking: Bool {
        get { bool(forKey: FilterKey.nonSmoking.rawValue) }
        set { set(newValue, forKey: FilterKey.nonSmoking.rawValue) }
    }
    
    var parking: Bool {
        get { bool(forKey: FilterKey.parking.rawValue) }
        set { set(newValue, forKey: FilterKey.parking.rawValue) }
    }
}