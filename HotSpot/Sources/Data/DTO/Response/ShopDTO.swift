import Foundation

struct ShopDTO: Decodable {
    let id: String
    let name: String
    let address: String
    let lat: Double
    let lng: Double
    let access: String
    let open: String?
    let photo: Photo
    let genre: Genre
    let budget: Budget?
    let wifi: String?
    let nonSmoking: String?
    let privateRoom: String?
    let parking: String?
    let urls: Urls
    
    struct Photo: Decodable {
        let pc: PcPhoto
        
        struct PcPhoto: Decodable {
            let large: String
            let medium: String
            let small: String
            
            enum CodingKeys: String, CodingKey {
                case large = "l"
                case medium = "m"
                case small = "s"
            }
        }
    }
    
    struct Genre: Decodable {
        let code: String
        let name: String
        let catchPhrase: String
        
        enum CodingKeys: String, CodingKey {
            case code
            case name
            case catchPhrase = "catch"
        }
        
        static func from(code: String) -> HotSpot.Genre? {
            return HotSpot.Genre(rawValue: code)
        }
    }
    
    struct Budget: Decodable {
        let code: String
        let name: String
        let average: String?
        
        static func from(code: String) -> HotSpot.Budget? {
            return HotSpot.Budget(rawValue: code)
        }
    }
    
    struct Urls: Decodable {
        let pc: String
    }
    
    enum CodingKeys: String, CodingKey {
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
    
    func toDomain() -> ShopModel {
        ShopModel(
            id: id,
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            imageUrl: photo.pc.large,
            access: access,
            openingHours: open ?? "営業時間情報なし",
            genre: Genre.from(code: genre.code) ?? .other,
            budget: budget.flatMap { Budget.from(code: $0.code) } ?? .from1501to2000,
            url: urls.pc,
            wifi: wifi == "あり" ? 1 : 0,
            privateRoom: privateRoom == "あり" ? 1 : 0,
            nonSmoking: nonSmoking == "あり" ? 1 : 0,
            parking: parking == "あり" ? 1 : 0
        )
    }
}
