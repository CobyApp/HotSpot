import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                Button(action: {
                    viewStore.send(.navigateToSettings)
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("HotSpot")
        }
    }
}

#Preview {
    SearchView(
        store: Store(
            initialState: SearchStore.State(),
            reducer: { SearchStore() }
        )
    )
} 
