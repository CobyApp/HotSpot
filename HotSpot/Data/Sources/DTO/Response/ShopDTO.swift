import Foundation

public struct ShopDTO: Decodable {
    public let id: String
    public let name: String
    public let address: String
    public let lat: Double
    public let lng: Double
    public let access: String
    public let open: String?
    public let photo: Photo
    public let genre: Genre
    public let budget: Budget?
    public let wifi: String?
    public let nonSmoking: String?
    public let privateRoom: String?
    public let parking: String?
    public let urls: Urls
    
    public struct Photo: Decodable {
        public let pc: PcPhoto
        
        public struct PcPhoto: Decodable {
            public let large: String
            public let medium: String
            public let small: String
            
            public enum CodingKeys: String, CodingKey {
                case large = "l"
                case medium = "m"
                case small = "s"
            }
        }
    }
    
    public struct Genre: Decodable {
        public let code: String
        public let name: String
        public let catchPhrase: String
        
        public enum CodingKeys: String, CodingKey {
            case code
            case name
            case catchPhrase = "catch"
        }
    }
    
    public struct Budget: Decodable {
        public let code: String
        public let name: String
        public let average: String?
    }
    
    public struct Urls: Decodable {
        public let pc: String
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case lat
        case lng
        case access
        case open
        case photo
        case genre
        case budget
        case wifi
        case nonSmoking = "non_smoking"
        case privateRoom = "private_room"
        case parking
        case urls
    }
}
