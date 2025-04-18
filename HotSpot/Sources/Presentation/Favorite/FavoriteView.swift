import SwiftUI
import ComposableArchitecture

struct FavoriteView: View {
    let store: StoreOf<FavoriteStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button(action: { viewStore.send(.pop) }) {
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
