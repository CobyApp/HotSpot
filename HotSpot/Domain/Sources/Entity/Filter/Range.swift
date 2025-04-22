import Foundation

enum Range: Int, CaseIterable {
    case threeHundredMeters = 1
    case fiveHundredMeters = 2
    case oneKilometer = 3
    case twoKilometers = 4
    case threeKilometers = 5
    
    var name: String {
        switch self {
        case .threeHundredMeters: return "300m"
        case .fiveHundredMeters: return "500m"
        case .oneKilometer: return "1km"
        case .twoKilometers: return "2km"
        case .threeKilometers: return "3km"
        }
    }
} 