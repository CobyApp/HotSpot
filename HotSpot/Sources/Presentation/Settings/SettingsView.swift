import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsStore>
    
    var body: some View {
        WithPerceptionTracking {
            List {
                Section("검색 설정") {
                    Picker("기본 검색 범위", selection: Binding(
                        get: { store.defaultSearchRange },
                        set: { store.send(.updateSearchRange($0)) }
                    )) {
                        Text("1km").tag(1)
                        Text("2km").tag(2)
                        Text("3km").tag(3)
                    }
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
