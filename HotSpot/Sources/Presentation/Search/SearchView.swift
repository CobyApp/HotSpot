import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchStore>
    
    var body: some View {
        WithPerceptionTracking {
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
                    
                    Button(action: {
                        store.send(.navigateToSettings)
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding()
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
