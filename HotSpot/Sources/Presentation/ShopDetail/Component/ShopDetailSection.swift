import SwiftUI
import CobyDS

struct ShopDetailSection: View {
    let shop: ShopModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Basic Info
            VStack(alignment: .leading, spacing: 12) {
                Text(shop.name)
                    .font(.pretendard(size: 24, weight: .bold))
                    .foregroundColor(Color.labelNormal)
                
                Text(shop.genre.name)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundColor(Color.labelAlternative)
            }
            
            // Facilities Grid
            VStack(alignment: .leading, spacing: 16) {
                Text("設備")
                    .font(.pretendard(size: 16, weight: .semibold))
                    .foregroundColor(Color.labelNormal)
                
                HStack(spacing: 0) {
                    FacilityIcon(
                        systemName: "wifi",
                        title: "Wi-Fi",
                        isAvailable: shop.wifi == 1
                    )
                    .frame(maxWidth: .infinity)
                    
                    FacilityIcon(
                        systemName: "door.left.hand.open",
                        title: "個室",
                        isAvailable: shop.privateRoom == 1
                    )
                    .frame(maxWidth: .infinity)
                    
                    FacilityIcon(
                        systemName: "chair",
                        title: "禁煙席",
                        isAvailable: shop.nonSmoking == 1
                    )
                    .frame(maxWidth: .infinity)
                    
                    FacilityIcon(
                        systemName: "car",
                        title: "駐車場",
                        isAvailable: shop.parking == 1
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            
            // Business Info
            VStack(alignment: .leading, spacing: 20) {
                // Budget
                InfoRow(title: "予算", content: shop.budget.name)
                
                // Open Hours
                InfoRow(title: "営業時間", content: shop.openingHours)
                
                // Access
                InfoRow(title: "アクセス", content: shop.address)
                
                // Address
                InfoRow(title: "住所", content: shop.access)
            }
            
            // URL Button
            if let url = URL(string: shop.url) {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "link")
                        
                        Text("ウェブサイトを見る")
                    }
                }
                .buttonStyle(
                    CBButtonStyle(
                        buttonType: .outlined,
                        buttonSize: .medium
                    )
                )
            }
            
            // Location Map
            VStack(alignment: .leading, spacing: 12) {
                Text("位置情報")
                    .font(.pretendard(size: 16, weight: .semibold))
                    .foregroundColor(Color.labelNormal)
                
                ShopLocationMapView(shop: shop)
                    .disabled(true)
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
        .padding(.vertical, BaseSize.verticalPadding)
    }
}

#Preview {
    ShopDetailSection(
        shop: ShopModel(
            id: "test",
            name: "テスト店舗",
            address: "東京都渋谷区",
            latitude: 35.6762,
            longitude: 139.6503,
            imageUrl: "https://example.com/image.jpg",
            access: "渋谷駅から徒歩5分",
            openingHours: "11:00-23:00",
            genre: .izakaya,
            budget: .from1501to2000,
            url: "https://example.com",
            wifi: 1,
            privateRoom: 1,
            nonSmoking: 1,
            parking: 1
        )
    )
}
