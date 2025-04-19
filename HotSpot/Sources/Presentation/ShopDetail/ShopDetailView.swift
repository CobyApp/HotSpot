import SwiftUI
import ComposableArchitecture
import CobyDS
import Kingfisher

struct ShopDetailView: View {
    let store: StoreOf<ShopDetailStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .left,
                    leftAction: {
                        viewStore.send(.pop)
                    }
                )
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        KFImage(URL(string: viewStore.shop.imageUrl))
                            .placeholder {
                                Image(uiImage: UIImage.icImage)
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(Color.labelAlternative)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.fillStrong)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 24) {
                            // Name and Genre
                            VStack(alignment: .leading, spacing: 8) {
                                Text(viewStore.shop.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(ShopGenre.name(for: viewStore.shop.genreCode))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            // Address
                            VStack(alignment: .leading, spacing: 4) {
                                Text("住所")
                                    .font(.headline)
                                Text(viewStore.shop.address)
                                    .font(.body)
                            }
                            
                            // Access
                            VStack(alignment: .leading, spacing: 4) {
                                Text("アクセス")
                                    .font(.headline)
                                Text(viewStore.shop.access)
                                    .font(.body)
                            }
                            
                            // Open Hours
                            if let openingHours = viewStore.shop.openingHours {
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
                                Text("緯度: \(viewStore.shop.latitude)")
                                    .font(.body)
                                Text("経度: \(viewStore.shop.longitude)")
                                    .font(.body)
                            }
                        }
                        .padding(.horizontal, BaseSize.horizantalPadding)
                        .padding(.vertical, BaseSize.verticalPadding)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ShopDetailView(
        store: Store(
            initialState: ShopDetailStore.State(
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
            ),
            reducer: { ShopDetailStore() }
        )
    )
}
