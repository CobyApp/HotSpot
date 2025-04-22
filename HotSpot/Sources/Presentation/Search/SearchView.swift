import SwiftUI
import CobyDS
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchStore>
    @State private var isSearchFocused = false
    @Environment(\.coordinator) private var coordinator
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 8) {
                if !isSearchFocused {
                    TopBarView(
                        leftSide: .left,
                        leftAction: {
                            coordinator?.pop()
                        },
                        rightSide: .icon,
                        rightIcon: UIImage.icFilter,
                        rightAction: {
                            coordinator?.showSearchFilter()
                        }
                    )
                }
                
                SearchBar(
                    searchText: viewStore.searchText,
                    onSearch: { viewStore.send(.search($0)) },
                    isSearchFocused: $isSearchFocused
                )
                .padding(.horizontal, BaseSize.horizantalPadding)
                .padding(.top, isSearchFocused ? BaseSize.verticalPadding : 0)
                
                SearchResults(
                    error: viewStore.error,
                    searchText: viewStore.searchText,
                    shops: viewStore.shops,
                    onSelectShop: { coordinator?.showShopDetail($0) },
                    onLoadMore: {
                        if !viewStore.isLastPage {
                            viewStore.send(.loadMore)
                        }
                    }
                )
            }
            .background(Color.backgroundNormalNormal)
            .onAppear {
                viewStore.send(.search(""))
            }
            .onChange(of: viewStore.error) { error in
                if let error = error {
                    coordinator?.showError(error)
                    viewStore.send(.clearError)
                }
            }
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
