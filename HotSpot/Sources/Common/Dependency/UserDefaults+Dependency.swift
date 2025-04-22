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
        case location = "location"
    }
    
    var range: Int {
        get { integer(forKey: FilterKey.range.rawValue) == 0 ? 3 : integer(forKey: FilterKey.range.rawValue) }
        set { set(newValue, forKey: FilterKey.range.rawValue) }
    }
    
    var location: MapCoordinate {
        get {
            let lat = double(forKey: "\(FilterKey.location.rawValue)_lat")
            let lng = double(forKey: "\(FilterKey.location.rawValue)_lng")
            return lat == 0 && lng == 0 
                ? MapCoordinate(latitude: 34.6937, longitude: 135.5023) // Osaka coordinates
                : MapCoordinate(latitude: lat, longitude: lng)
        }
        set {
            set(newValue.latitude, forKey: "\(FilterKey.location.rawValue)_lat")
            set(newValue.longitude, forKey: "\(FilterKey.location.rawValue)_lng")
        }
    }
    
    var budgets: [String] {
        get { stringArray(forKey: FilterKey.budgets.rawValue) ?? [] }
        set { set(newValue, forKey: FilterKey.budgets.rawValue) }
    }
    
    var genres: [String] {
        get { stringArray(forKey: FilterKey.genres.rawValue) ?? [] }
        set { set(newValue, forKey: FilterKey.genres.rawValue) }
    }
    
    var wifi: Int {
        get { integer(forKey: FilterKey.wifi.rawValue) }
        set { set(newValue, forKey: FilterKey.wifi.rawValue) }
    }
    
    var privateRoom: Int {
        get { integer(forKey: FilterKey.privateRoom.rawValue) }
        set { set(newValue, forKey: FilterKey.privateRoom.rawValue) }
    }
    
    var nonSmoking: Int {
        get { integer(forKey: FilterKey.nonSmoking.rawValue) }
        set { set(newValue, forKey: FilterKey.nonSmoking.rawValue) }
    }
    
    var parking: Int {
        get { integer(forKey: FilterKey.parking.rawValue) }
        set { set(newValue, forKey: FilterKey.parking.rawValue) }
    }
}