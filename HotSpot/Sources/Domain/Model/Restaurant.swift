import Foundation

struct Restaurant: Identifiable, Equatable {
    let id: UUID
    let name: String
    let address: String
    let imageURL: URL?
    let phone: String?
    
    init(id: UUID = UUID(), name: String, address: String, imageURL: URL? = nil, phone: String? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.imageURL = imageURL
        self.phone = phone
    }
} 