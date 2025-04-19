import SwiftUI

import CobyDS
import ComposableArchitecture

struct RestaurantDetailView: View {
    let store: StoreOf<RestaurantDetailStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .left,
                    leftAction: {
                        viewStore.send(.pop)
                    },
                    title: viewStore.restaurant?.name ?? "Restaurant"
                )
                
                if viewStore.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let restaurant = viewStore.restaurant {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Restaurant Image
                            if let imageURL = restaurant.imageURL {
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
                            
                            // Restaurant Info
                            VStack(alignment: .leading, spacing: 12) {
                                Text(restaurant.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(restaurant.address)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                if let phone = restaurant.phone {
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
    RestaurantDetailView(
        store: Store(
            initialState: RestaurantDetailStore.State(restaurantId: UUID()),
            reducer: { RestaurantDetailStore() }
        )
    )
} 
