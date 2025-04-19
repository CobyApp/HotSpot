import SwiftUI
import ComposableArchitecture
import CobyDS
import Kingfisher

struct ShopDetailView: View {
    let store: StoreOf<ShopDetailStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                VStack(spacing: 0) {
                    TopBarView(
                        leftSide: .left,
                        leftAction: {
                            viewStore.send(.pop)
                        }
                    )
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 8) {
                            ShopImageSection(imageUrl: viewStore.shop.imageUrl)
                            
                            ShopInfoSection(shop: viewStore.shop)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
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
