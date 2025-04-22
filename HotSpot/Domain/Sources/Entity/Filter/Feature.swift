import Foundation

public enum Feature: String, CaseIterable {
    case wifi = "Wi-Fiあり"
    case privateRoom = "個室あり"
    case nonSmoking = "禁煙席あり"
    case parking = "駐車場あり"
    
    public var name: String {
        return self.rawValue
    }
} 