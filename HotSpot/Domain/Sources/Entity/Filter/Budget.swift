import UIKit

public enum Budget: String, CaseIterable {
    case under500 = "B009"          // ～500円
    case from501to1000 = "B010"     // 501～1000円
    case from1001to1500 = "B011"    // 1001～1500円
    case from1501to2000 = "B001"    // 1501～2000円
    case from2001to3000 = "B002"    // 2001～3000円
    case from3001to4000 = "B003"    // 3001～4000円
    case from4001to5000 = "B008"    // 4001～5000円
    case from5001to7000 = "B004"    // 5001～7000円
    case from7001to10000 = "B005"   // 7001～10000円
    case from10001to15000 = "B006"  // 10001～15000円
    case from15001to20000 = "B012"  // 15001～20000円
    case from20001to30000 = "B013"  // 20001～30000円
    case over30001 = "B014"         // 30001円～
    
    public var name: String {
        switch self {
        case .under500: return "～500円"
        case .from501to1000: return "501～1000円"
        case .from1001to1500: return "1001～1500円"
        case .from1501to2000: return "1501～2000円"
        case .from2001to3000: return "2001～3000円"
        case .from3001to4000: return "3001～4000円"
        case .from4001to5000: return "4001～5000円"
        case .from5001to7000: return "5001～7000円"
        case .from7001to10000: return "7001～10000円"
        case .from10001to15000: return "10001～15000円"
        case .from15001to20000: return "15001～20000円"
        case .from20001to30000: return "20001～30000円"
        case .over30001: return "30001円～"
        }
    }
    
    public var minPrice: Int {
        switch self {
        case .under500: return 0
        case .from501to1000: return 501
        case .from1001to1500: return 1001
        case .from1501to2000: return 1501
        case .from2001to3000: return 2001
        case .from3001to4000: return 3001
        case .from4001to5000: return 4001
        case .from5001to7000: return 5001
        case .from7001to10000: return 7001
        case .from10001to15000: return 10001
        case .from15001to20000: return 15001
        case .from20001to30000: return 20001
        case .over30001: return 30001
        }
    }
    
    public var maxPrice: Int? {
        switch self {
        case .under500: return 500
        case .from501to1000: return 1000
        case .from1001to1500: return 1500
        case .from1501to2000: return 2000
        case .from2001to3000: return 3000
        case .from3001to4000: return 4000
        case .from4001to5000: return 5000
        case .from5001to7000: return 7000
        case .from7001to10000: return 10000
        case .from10001to15000: return 15000
        case .from15001to20000: return 20000
        case .from20001to30000: return 30000
        case .over30001: return nil
        }
    }
    
    public static func from(code: String) -> Budget? {
        return Budget(rawValue: code)
    }
} 