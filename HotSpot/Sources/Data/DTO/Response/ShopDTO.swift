import Foundation

struct ShopDTO: Decodable {
    let id: String
    let name: String
    let nameKana: String?
    let address: String
    let stationName: String?
    let lat: Double
    let lng: Double
    let access: String
    let open: String?
    let close: String?
    let photo: Photo
    let genre: Genre
    let catchPhrase: String
    let budget: Budget?
    let wifi: String?
    let nonSmoking: String?
    let privateRoom: String?
    let card: String?
    
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
    }
    
    struct Budget: Decodable {
        let code: String
        let name: String
        let average: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameKana = "name_kana"
        case address
        case stationName = "station_name"
        case lat
        case lng
        case access
        case open
        case close
        case photo
        case genre
        case catchPhrase = "catch"
        case budget
        case wifi
        case nonSmoking = "non_smoking"
        case privateRoom = "private_room"
        case card
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
            openingHours: open,
            genreCode: genre.code
        )
    }
}
