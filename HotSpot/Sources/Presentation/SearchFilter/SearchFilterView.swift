import SwiftUI
import ComposableArchitecture
import CobyDS

struct SearchFilterView: View {
    let store: StoreOf<SearchFilterStore>
    @Environment(\.coordinator) private var coordinator
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                RangeSection(
                    selectedRange: viewStore.selectedRange,
                    onRangeSelected: { range in
                        viewStore.send(.updateRange(range))
                    }
                )
                
                BudgetSection(
                    selectedBudgetCode: viewStore.selectedBudget,
                    onBudgetSelected: { budgetCode in
                        viewStore.send(.updateBudget(budgetCode))
                    }
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
