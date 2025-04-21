import SwiftUI
import ComposableArchitecture
import CobyDS

struct SearchFilterView: View {
    let store: StoreOf<SearchFilterStore>
    @Environment(\.coordinator) private var coordinator
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                DistanceSection(
                    selectedDistance: viewStore.selectedDistance,
                    onDistanceSelected: { viewStore.send(.updateDistance($0)) }
                )
                
                BudgetSection(
                    selectedBudget: viewStore.selectedBudget,
                    onBudgetSelected: { viewStore.send(.updateBudget($0)) }
                )
                
                GenreSection(
                    selectedGenreCode: viewStore.selectedGenreCode,
                    onGenreSelected: { viewStore.send(.updateGenre($0)) }
                )
                
                VStack(spacing: 8) {
                    Toggle("WiFi", isOn: viewStore.binding(
                        get: \.hasWiFi,
                        send: { .updateWiFi($0) }
                    ))
                    
                    Toggle("개인실", isOn: viewStore.binding(
                        get: \.hasPrivateRoom,
                        send: { .updatePrivateRoom($0) }
                    ))
                    
                    Toggle("금연", isOn: viewStore.binding(
                        get: \.isNonSmoking,
                        send: { .updateNonSmoking($0) }
                    ))
                }
                .padding(.horizontal)
                
                Button("필터 초기화") {
                    viewStore.send(.resetFilters)
                }
                .padding()
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
