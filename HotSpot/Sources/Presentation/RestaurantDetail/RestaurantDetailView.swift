import SwiftUI
import ComposableArchitecture

struct RestaurantDetailView: View {
    @Bindable var store: StoreOf<RestaurantDetailStore>
    
    var body: some View {
        VStack {
            Button(action: { store.send(.toggleFavorite) }) {
                Label(
                    store.isFavorite ? "즐겨찾기 제거" : "즐겨찾기 추가",
                    systemImage: store.isFavorite ? "star.fill" : "star"
                )
            }
            .buttonStyle(.bordered)
            
            Button(action: { store.send(.navigateToSettings) }) {
                Label("설정", systemImage: "gear")
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("맛집 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(
            store: Store(
                initialState: RestaurantDetailStore.State()
            ) {
                RestaurantDetailStore()
            }
        )
    }
} 