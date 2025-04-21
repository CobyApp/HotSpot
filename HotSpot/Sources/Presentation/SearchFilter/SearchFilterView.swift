import SwiftUI
import ComposableArchitecture

struct SearchFilterView: View {
    let store: StoreOf<SearchFilterStore>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                FilterForm(viewStore: viewStore)
            }
        }
    }
}

private struct FilterForm: View {
    let viewStore: ViewStore<SearchFilterStore.State, SearchFilterStore.Action>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            BudgetSection(viewStore: viewStore)
            FeaturesSection(viewStore: viewStore)
            CuisineSection(viewStore: viewStore)
            DistanceSection(viewStore: viewStore)
        }
        .navigationTitle("Filter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Reset") {
                    viewStore.send(.resetFilters)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Apply") {
                    viewStore.send(.applyFilters)
                    dismiss()
                }
            }
        }
    }
}

private struct BudgetSection: View {
    let viewStore: ViewStore<SearchFilterStore.State, SearchFilterStore.Action>
    
    var body: some View {
        Section(header: Text("Budget")) {
            Picker("Budget", selection: viewStore.binding(
                get: \.selectedBudget,
                send: SearchFilterStore.Action.updateBudget
            )) {
                Text("Any").tag(0)
                Text("¥1,000~").tag(1)
                Text("¥3,000~").tag(2)
                Text("¥5,000~").tag(3)
                Text("¥10,000~").tag(4)
            }
        }
    }
}

private struct FeaturesSection: View {
    let viewStore: ViewStore<SearchFilterStore.State, SearchFilterStore.Action>
    
    var body: some View {
        Section(header: Text("Features")) {
            Toggle("WiFi Available", isOn: viewStore.binding(
                get: \.hasWiFi,
                send: SearchFilterStore.Action.toggleWiFi
            ))
            Toggle("Private Room", isOn: viewStore.binding(
                get: \.hasPrivateRoom,
                send: SearchFilterStore.Action.togglePrivateRoom
            ))
            Toggle("Non-Smoking", isOn: viewStore.binding(
                get: \.isNonSmoking,
                send: SearchFilterStore.Action.toggleNonSmoking
            ))
            Toggle("Parking Available", isOn: viewStore.binding(
                get: \.hasParking,
                send: SearchFilterStore.Action.toggleParking
            ))
        }
    }
}

private struct CuisineSection: View {
    let viewStore: ViewStore<SearchFilterStore.State, SearchFilterStore.Action>
    
    var body: some View {
        Section(header: Text("Cuisine")) {
            Picker("Cuisine", selection: viewStore.binding(
                get: \.selectedCuisine,
                send: SearchFilterStore.Action.updateCuisine
            )) {
                Text("Any").tag(0)
                Text("Japanese").tag(1)
                Text("Italian").tag(2)
                Text("French").tag(3)
                Text("Chinese").tag(4)
            }
        }
    }
}

private struct DistanceSection: View {
    let viewStore: ViewStore<SearchFilterStore.State, SearchFilterStore.Action>
    
    var body: some View {
        Section(header: Text("Distance")) {
            Picker("Distance", selection: viewStore.binding(
                get: \.selectedDistance,
                send: SearchFilterStore.Action.updateDistance
            )) {
                Text("300m").tag(1)
                Text("500m").tag(2)
                Text("1km").tag(3)
                Text("2km").tag(4)
                Text("3km").tag(5)
            }
        }
    }
}

#Preview {
    SearchFilterView(
        store: Store(
            initialState: SearchFilterStore.State(),
            reducer: { SearchFilterStore() }
        )
    )
} 
