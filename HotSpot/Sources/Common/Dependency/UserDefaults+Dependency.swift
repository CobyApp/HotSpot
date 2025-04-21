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
    enum FilterKey {
        static let distance = "distance"
        static let budget = "budget"
        static let genre = "genre"
        static let wifi = "wifi"
        static let privateRoom = "private_room"
        static let nonSmoking = "non_smoking"
        static let parking = "parking"
    }
    
    var distance: Int {
        get { integer(forKey: FilterKey.distance) }
        set { set(newValue, forKey: FilterKey.distance) }
    }
    
    var budget: Int {
        get { integer(forKey: FilterKey.budget) }
        set { set(newValue, forKey: FilterKey.budget) }
    }
    
    var genre: String {
        get { string(forKey: FilterKey.genre) ?? "" }
        set { set(newValue, forKey: FilterKey.genre) }
    }
    
    var wifi: Bool {
        get { bool(forKey: FilterKey.wifi) }
        set { set(newValue, forKey: FilterKey.wifi) }
    }
    
    var privateRoom: Bool {
        get { bool(forKey: FilterKey.privateRoom) }
        set { set(newValue, forKey: FilterKey.privateRoom) }
    }
    
    var nonSmoking: Bool {
        get { bool(forKey: FilterKey.nonSmoking) }
        set { set(newValue, forKey: FilterKey.nonSmoking) }
    }
    
    var parking: Bool {
        get { bool(forKey: FilterKey.parking) }
        set { set(newValue, forKey: FilterKey.parking) }
    }
}