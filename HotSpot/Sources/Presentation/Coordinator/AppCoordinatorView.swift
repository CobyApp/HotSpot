import SwiftUI
import ComposableArchitecture

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                MapView(store: store.scope(state: \.map, action: \.map))
                    .background(
                        Group {
                            searchNavigationLink(viewStore: viewStore)
                            mapToDetailNavigationLink(viewStore: viewStore)
                        }
                    )
            }
            .navigationViewStyle(.stack)
        }
    }
    
    private func searchNavigationLink(viewStore: ViewStore<AppCoordinator.State, AppCoordinator.Action>) -> some View {
        NavigationLink(
            destination: IfLetStore(
                store.scope(state: \.search, action: \.search),
                then: { store in
                    SearchView(store: store)
                        .background(searchToDetailNavigationLink(viewStore: viewStore))
                }
            ),
            isActive: viewStore.binding(
                get: { $0.search != nil },
                send: { $0 ? .showSearch : .dismissSearch }
            )
        ) {
            EmptyView()
        }
        .hidden()
    }
    
    private func mapToDetailNavigationLink(viewStore: ViewStore<AppCoordinator.State, AppCoordinator.Action>) -> some View {
        NavigationLink(
            destination: IfLetStore(
                store.scope(state: \.shopDetail, action: \.shopDetail),
                then: { store in
                    ShopDetailView(store: store)
                }
            ),
            isActive: viewStore.binding(
                get: { $0.isDetailPresented && $0.search == nil },
                send: { $0 ? .showShopDetail(viewStore.selectedShop!) : .dismissDetail }
            )
        ) {
            EmptyView()
        }
        .hidden()
    }
    
    private func searchToDetailNavigationLink(viewStore: ViewStore<AppCoordinator.State, AppCoordinator.Action>) -> some View {
        NavigationLink(
            destination: IfLetStore(
                store.scope(state: \.shopDetail, action: \.shopDetail),
                then: { store in
                    ShopDetailView(store: store)
                }
            ),
            isActive: viewStore.binding(
                get: { $0.isDetailPresented && $0.search != nil },
                send: { $0 ? .showShopDetail(viewStore.selectedShop!) : .dismissDetail }
            )
        ) {
            EmptyView()
        }
        .hidden()
    }
}

#Preview {
    AppCoordinatorView(
        store: Store(
            initialState: AppCoordinator.State(),
            reducer: { AppCoordinator() }
        )
    )
}
