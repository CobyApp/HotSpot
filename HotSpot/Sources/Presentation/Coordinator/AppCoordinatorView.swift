import SwiftUI
import ComposableArchitecture

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>

    var body: some View {
        NavigationView {
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack {
                    SearchView(store: store.scope(state: \.search, action: \.search))

                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.restaurantDetail, action: \.restaurantDetail),
                            then: RestaurantDetailView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0.restaurantDetail != nil },
                            send: { $0 ? .showRestaurantDetail : .dismissDetail }
                        )
                    ) {
                        EmptyView()
                    }
                    .hidden()

                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.favorite, action: \.favorite),
                            then: FavoriteView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0.favorite != nil },
                            send: { $0 ? .navigateToFavorite : .dismissFavorite }
                        )
                    ) {
                        EmptyView()
                    }
                    .hidden()

                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(state: \.settings, action: \.settings),
                            then: SettingsView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0.settings != nil },
                            send: { $0 ? .navigateToSettings : .dismissSettings }
                        )
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        }
    }
}
