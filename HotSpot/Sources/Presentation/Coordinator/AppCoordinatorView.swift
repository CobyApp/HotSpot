import SwiftUI
import ComposableArchitecture

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    MapView(store: store.scope(state: \.map, action: { .map($0) }))
                    
                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.search, action: { .search($0) }),
                            then: { store in
                                SearchView(store: store)
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
                    
                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.shopDetail, action: { .shopDetail($0) }),
                            then: { store in
                                ShopDetailView(store: store)
                            }
                        ),
                        isActive: viewStore.binding(
                            get: { $0.isDetailPresented },
                            send: { $0 ? .showShopDetail(viewStore.selectedShop!) : .dismissDetail }
                        )
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
