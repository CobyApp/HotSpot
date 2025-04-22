import SwiftUI
import ComposableArchitecture
import CobyDS

struct SearchFilterView: View {
    let store: StoreOf<SearchFilterStore>
    @Environment(\.coordinator) private var coordinator
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .left,
                    leftAction: {
                        coordinator?.pop()
                    },
                    rightSide: .icon,
                    rightIcon: UIImage.icRefresh,
                    rightAction: {
                        viewStore.send(.resetFilters)
                    }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        RangeSection(
                            selectedRange: viewStore.selectedRange,
                            onRangeSelected: { range in
                                viewStore.send(.updateRange(range))
                            }
                        )
                        
                        BudgetSection(
                            selectedBudgets: viewStore.selectedBudgets,
                            onBudgetSelected: { budgetCode in
                                var updatedBudgets = viewStore.selectedBudgets
                                if updatedBudgets.contains(budgetCode) {
                                    updatedBudgets.removeAll { $0 == budgetCode }
                                } else if updatedBudgets.count < 2 {
                                    updatedBudgets.append(budgetCode)
                                }
                                viewStore.send(.updateBudgets(updatedBudgets))
                            }
                        )
                        
                        GenreSection(
                            selectedGenres: viewStore.selectedGenres,
                            onGenreSelected: { genreCode in
                                var updatedGenres = viewStore.selectedGenres
                                if updatedGenres.contains(genreCode) {
                                    updatedGenres.removeAll { $0 == genreCode }
                                } else {
                                    updatedGenres.append(genreCode)
                                }
                                viewStore.send(.updateGenres(updatedGenres))
                            }
                        )
                        
                        FeaturesSection(
                            wifi: viewStore.wifi,
                            privateRoom: viewStore.privateRoom,
                            nonSmoking: viewStore.nonSmoking,
                            parking: viewStore.parking,
                            onWiFiTapped: { viewStore.send(.updateWiFi(viewStore.wifi == 0 ? 1 : 0)) },
                            onPrivateRoomTapped: { viewStore.send(.updatePrivateRoom(viewStore.privateRoom == 0 ? 1 : 0)) },
                            onNonSmokingTapped: { viewStore.send(.updateNonSmoking(viewStore.nonSmoking == 0 ? 1 : 0)) },
                            onParkingTapped: { viewStore.send(.updateParking(viewStore.parking == 0 ? 1 : 0)) }
                        )
                    }
                    .padding(.vertical, 16)
                }
                
                Button {
                    viewStore.send(.applyFilters)
                    coordinator?.pop()
                } label: {
                    Text("フィルターを適用")
                }
                .buttonStyle(
                    CBButtonStyle()
                )
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.bottom, BaseSize.verticalPadding)
            }
            .background(Color.backgroundNormalNormal)
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
