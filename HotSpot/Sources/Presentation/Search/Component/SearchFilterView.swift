import SwiftUI
import ComposableArchitecture

struct SearchFilterView: View {
    let store: StoreOf<SearchStore>
    let coordinatorStore: StoreOf<AppCoordinator>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            WithViewStore(coordinatorStore, observe: { $0 }) { coordinatorViewStore in
                NavigationView {
                    FilterForm(viewStore: viewStore, coordinatorViewStore: coordinatorViewStore)
                }
            }
        }
    }
}

private struct FilterForm: View {
    let viewStore: ViewStore<SearchStore.State, SearchStore.Action>
    let coordinatorViewStore: ViewStore<AppCoordinator.State, AppCoordinator.Action>
    
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
                    viewStore.send(.search(viewStore.searchText))
                    viewStore.send(.toggleFilterSheet)
                }
            }
        }
    }
}

private struct BudgetSection: View {
    let viewStore: ViewStore<SearchStore.State, SearchStore.Action>
    
    var body: some View {
        Section(header: Text("Budget")) {
            Picker("Budget", selection: viewStore.binding(
                get: \.selectedBudget,
                send: SearchStore.Action.updateBudget
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
    let viewStore: ViewStore<SearchStore.State, SearchStore.Action>
    
    var body: some View {
        Section(header: Text("Features")) {
            Toggle("WiFi Available", isOn: viewStore.binding(
                get: \.hasWiFi,
                send: SearchStore.Action.toggleWiFi
            ))
            Toggle("Private Room", isOn: viewStore.binding(
                get: \.hasPrivateRoom,
                send: SearchStore.Action.togglePrivateRoom
            ))
            Toggle("Non-Smoking", isOn: viewStore.binding(
                get: \.isNonSmoking,
                send: SearchStore.Action.toggleNonSmoking
            ))
            Toggle("Parking Available", isOn: viewStore.binding(
                get: \.hasParking,
                send: SearchStore.Action.toggleParking
            ))
        }
    }
}

private struct CuisineSection: View {
    let viewStore: ViewStore<SearchStore.State, SearchStore.Action>
    
    var body: some View {
        Section(header: Text("Cuisine")) {
            Picker("Cuisine", selection: viewStore.binding(
                get: \.selectedCuisine,
                send: SearchStore.Action.updateCuisine
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
    let viewStore: ViewStore<SearchStore.State, SearchStore.Action>
    
    var body: some View {
        Section(header: Text("Distance")) {
            Picker("Distance", selection: viewStore.binding(
                get: \.selectedDistance,
                send: SearchStore.Action.updateDistance
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
            initialState: SearchStore.State(),
            reducer: { SearchStore() }
        ),
        coordinatorStore: Store(
            initialState: AppCoordinator.State(),
            reducer: { AppCoordinator() }
        )
    )
} 