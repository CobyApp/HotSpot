import SwiftUI
import ComposableArchitecture

struct FavoriteView: View {
    @Bindable var store: StoreOf<FavoriteStore>
    
    var body: some View {
        ContentUnavailableView(
            "즐겨찾기 없음",
            systemImage: "star",
            description: Text("맛집을 즐겨찾기에 추가해보세요")
        )
        .navigationTitle("즐겨찾기")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { store.send(.pop) }) {
                    Label("뒤로", systemImage: "chevron.left")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoriteView(store: Store(initialState: FavoriteStore.State()) {
            FavoriteStore()
        })
    }
} 