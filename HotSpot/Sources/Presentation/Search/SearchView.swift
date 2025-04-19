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
                        },
                        title: "Search"
                    )
                }
                
                SearchBar(
                    searchText: viewStore.searchText,
                    onSearch: { viewStore.send(.search($0)) }
                )
                
                SearchResults(
                    error: viewStore.error,
                    searchText: viewStore.searchText,
                    shops: viewStore.shops,
                    onSelectShop: { viewStore.send(.selectShop($0)) }
                )
            }
            .navigationBarHidden(true)
            .onTapGesture {
                isSearchFocused = false
            }
            .onAppear {
                viewStore.send(.onAppear)
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
