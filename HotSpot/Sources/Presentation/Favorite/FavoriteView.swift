import SwiftUI
import ComposableArchitecture

struct FavoriteView: View {
    let store: StoreOf<FavoriteStore>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Button(action: { store.send(.pop) }) {
                    Label("뒤로", systemImage: "chevron.left")
                }
            }
        }
    }
}

#Preview {
    FavoriteView(store: Store(initialState: FavoriteStore.State()) {
        FavoriteStore()
    })
}
