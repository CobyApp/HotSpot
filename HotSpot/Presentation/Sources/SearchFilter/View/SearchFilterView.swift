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
                            selectedRange: viewStore.selectedRange.rawValue,
                            onRangeSelected: { range in
                                if let range = Range(rawValue: range) {
                                    viewStore.send(.updateRange(range))
                                }
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
                            selectedFeatures: viewStore.selectedFeatures,
                            onFeatureSelected: { feature in
                                var updatedFeatures = viewStore.selectedFeatures
                                if updatedFeatures.contains(feature) {
                                    updatedFeatures.remove(feature)
                                } else {
                                    updatedFeatures.insert(feature)
                                }
                                viewStore.send(.updateFeatures(updatedFeatures))
                            }
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
                    CBButtonStyle(
                        buttonColor: Color.limeNormal
                    )
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
