import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    @Bindable var store: StoreOf<SearchStore>
    
    var body: some View {
        VStack(spacing: 16) {
            // Range Selection
            HStack {
                Spacer()
                
                Picker("범위", selection: Binding(
                    get: { store.selectedRange },
                    set: { store.send(.updateRange($0)) }
                )) {
                    Text("1km").tag(1)
                    Text("2km").tag(2)
                    Text("3km").tag(3)
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
            }
            .padding()
        }
        .navigationTitle("HotSpot")
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(
                initialState: SearchStore.State(),
                reducer: { SearchStore() }
            )
        )
    }
} 