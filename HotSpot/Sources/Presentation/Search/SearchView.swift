import SwiftUI
import CoreLocation
import CobyDS
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchStore>
    @State private var isSearchFocused = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                if !isSearchFocused {
                    TopBarView(
                        leftSide: .left,
                        leftAction: {
                            dismiss()
                        },
                        rightSide: .icon,
                        rightIcon: UIImage.icMore,
                        rightAction: {
                            viewStore.send(.toggleFilterSheet)
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
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isFilterSheetPresented,
                send: SearchStore.Action.toggleFilterSheet
            )) {
                SearchFilterView(store: store)
            }
            .background(
                NavigationLink(
                    destination: ShopDetailView(
                        store: Store(
                            initialState: ShopDetailStore.State(
                                shop: viewStore.selectedShop ?? ShopModel(
                                    id: "",
                                    name: "",
                                    address: "",
                                    latitude: 0,
                                    longitude: 0,
                                    imageUrl: "",
                                    access: "",
                                    openingHours: "",
                                    genreCode: ""
                                )
                            ),
                            reducer: { ShopDetailStore() }
                        )
                    ),
                    isActive: viewStore.binding(
                        get: { $0.navigationPath.contains { if case .shopDetail = $0 { return true } else { return false } } },
                        send: { _ in .pop }
                    )
                ) { EmptyView() }
            )
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
