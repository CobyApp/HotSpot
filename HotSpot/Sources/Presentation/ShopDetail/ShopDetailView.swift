import SwiftUI
import ComposableArchitecture
import CobyDS

struct ShopDetailView: View {
    let store: StoreOf<ShopDetailStore>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image
                    AsyncImage(url: URL(string: viewStore.shop.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 200)
                    .clipped()

                    // Shop Info
                    VStack(alignment: .leading, spacing: 16) {
                        // Name and Genre
                        VStack(alignment: .leading, spacing: 8) {
                            Text(viewStore.shop.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(viewStore.shop.genreCode)
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
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewStore.send(.pop)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    NavigationView {
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
} 
