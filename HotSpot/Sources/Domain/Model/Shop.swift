import Foundation

struct Shop: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let imageURL: URL?
    let phone: String?
    let location: Location?
    
    init(id: String = "", name: String, address: String, imageURL: URL? = nil, phone: String? = nil, location: Location?) {
        self.id = id
        self.name = name
        self.address = address
        self.imageURL = imageURL
        self.phone = phone
        self.location = location
    }
}
