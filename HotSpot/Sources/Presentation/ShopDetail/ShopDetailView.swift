import SwiftUI

import CobyDS
import ComposableArchitecture

struct ShopDetailView: View {
    let store: StoreOf<ShopDetailStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .left,
                    leftAction: {
                        viewStore.send(.pop)
                    },
                    title: viewStore.shop?.name ?? "Shop"
                )
                
                if viewStore.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let shop = viewStore.shop {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Shop Image
                            if let imageURL = shop.imageURL {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(height: 200)
                                .clipped()
                            }
                            
                            // Shop Info
                            VStack(alignment: .leading, spacing: 12) {
                                Text(shop.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(shop.address)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                if let phone = shop.phone {
                                    Text(phone)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    Text("레스토랑 정보를 불러올 수 없습니다.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    ShopDetailView(
        store: Store(
            initialState: ShopDetailStore.State(shopId: ""),
            reducer: { ShopDetailStore() }
        )
    )
} 
