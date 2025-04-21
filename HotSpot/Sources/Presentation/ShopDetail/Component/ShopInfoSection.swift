import SwiftUI
import CobyDS

struct ShopInfoSection: View {
    let shop: ShopModel
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 24) {
                // Name and Genre
                VStack(alignment: .leading, spacing: 8) {
                    Text(shop.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(ShopGenre.name(for: shop.genreCode))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Address
                VStack(alignment: .leading, spacing: 4) {
                    Text("住所")
                        .font(.headline)
                    Text(shop.address)
                        .font(.body)
                }
                
                // Access
                VStack(alignment: .leading, spacing: 4) {
                    Text("アクセス")
                        .font(.headline)
                    Text(shop.access)
                        .font(.body)
                }
                
                // Open Hours
                if let openingHours = shop.openingHours {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("営業時間")
                            .font(.headline)
                        Text(openingHours)
                            .font(.body)
                    }
                }
                
                // Location
                VStack(alignment: .leading, spacing: 4) {
                    Text("位置情報")
                        .font(.headline)
                    
                    ShopLocationMapView(shop: shop)
                }
            }
            .padding(.horizontal, BaseSize.horizantalPadding)
            .padding(.vertical, BaseSize.verticalPadding)
        }
    }
}

#Preview {
    ShopInfoSection(
        shop: ShopModel(
            id: "test",
            name: "テスト店舗",
            address: "東京都渋谷区",
            latitude: 35.6762,
            longitude: 139.6503,
            imageUrl: "https://example.com/image.jpg",
            access: "渋谷駅から徒歩5分",
            openingHours: "11:00-23:00",
            genreCode: "G001"
        )
    )
} 
