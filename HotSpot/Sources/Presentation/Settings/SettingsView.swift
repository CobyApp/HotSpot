import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                Button(action: {
                    viewStore.send(.updateSearchRange(1))
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(
        store: Store(
            initialState: SettingsStore.State(),
            reducer: { SettingsStore() }
        )
    )
} 
