import SwiftUI
import ComposableArchitecture

struct ShopCell: View {
    let shop: Shop
    
    var body: some View {
        HStack(spacing: 12) {
            // Shop Image
            AsyncImage(url: shop.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            // Shop Info
            VStack(alignment: .leading, spacing: 4) {
                Text(shop.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(shop.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let phone = shop.phone {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ShopCell(
        shop: Shop(
            id: "1",
            name: "BBQ치킨 강남점",
            address: "서울시 강남구 테헤란로 123",
            imageURL: URL(string: "https://example.com/image1.jpg"),
            phone: "02-123-4567",
            location: Location(lat: 37.5665, lon: 126.9780)
        )
    )
    .previewLayout(.sizeThatFits)
    .padding()
} 
