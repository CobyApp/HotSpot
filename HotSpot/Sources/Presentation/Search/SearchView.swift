import SwiftUI
import CoreLocation

import CobyDS
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchStore>
    @State private var isSearchFocused = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                if !isSearchFocused {
                    TopBarView(
                        leftSide: .left,
                        leftAction: {
                            viewStore.send(.pop)
                        }
                    )
                }
                
                SearchBar(
                    searchText: viewStore.searchText,
                    onSearch: { viewStore.send(.search($0)) },
                    isSearchFocused: $isSearchFocused
                )
                
                SearchResults(
                    error: viewStore.error,
                    searchText: viewStore.searchText,
                    shops: viewStore.shops,
                    onSelectShop: { viewStore.send(.selectShop($0)) },
                    onLoadMore: {
                        if !viewStore.paginationState.isLastPage {
                            viewStore.send(.loadMore)
                        }
                    }
                )
            }
            .navigationBarHidden(true)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
