import SwiftUI
import ComposableArchitecture

struct RestaurantDetailView: View {
    let store: StoreOf<RestaurantDetailStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button(action: { viewStore.send(.navigateToSettings) }) {
                    Label("설정", systemImage: "gear")
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("맛집 상세")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RestaurantDetailView(
        store: Store(
            initialState: RestaurantDetailStore.State()
        ) {
            RestaurantDetailStore()
        }
    )
} 
