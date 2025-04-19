import SwiftUI
import ComposableArchitecture

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    MapView(store: store.scope(state: \.map, action: \.map))
                    
                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.search, action: \.search),
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
                            store.scope(state: \.restaurantDetail, action: \.restaurantDetail),
                            then: { store in
                                RestaurantDetailView(store: store)
                            }
                        ),
                        isActive: viewStore.binding(
                            get: { $0.restaurantDetail != nil },
                            send: { $0 ? .showRestaurantDetail(viewStore.selectedRestaurantId ?? UUID()) : .dismissDetail }
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
