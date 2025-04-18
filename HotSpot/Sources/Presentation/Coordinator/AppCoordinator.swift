import SwiftUI
import ComposableArchitecture

@Reducer
struct AppCoordinator {
    @ObservableState
    struct State: Equatable {
        var path: StackState<Path.State> = StackState()
        var search: SearchStore.State
        
        init(search: SearchStore.State = .init()) {
            self.search = search
        }
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case search(SearchStore.Action)
        case resetNavigation
        case navigateToFavorite
        case navigateToSettings
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case search(SearchStore)
        case restaurantDetail(RestaurantDetailStore)
        case favorite(FavoriteStore)
        case settings(SettingsStore)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.search, action: \.search) {
            SearchStore()
        }
        
        Reduce { state, action in
            switch action {
            case .search(.showRestaurantDetail):
                state.path.append(.restaurantDetail(.init()))
                return .none
                
            case .navigateToFavorite:
                state.path.append(.favorite(.init()))
                return .none
                
            case .navigateToSettings:
                state.path.append(.settings(.init()))
                return .none
                
            case .resetNavigation:
                state.path = StackState()
                return .none
                
            case .path:
                return .none
                
            case .search:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path.body
        }
    }
}

struct AppCoordinatorView: View {
    @Bindable var store: StoreOf<AppCoordinator>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            SearchView(store: store.scope(state: \.search, action: \.search))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { store.send(.navigateToFavorite) }) {
                                Label("즐겨찾기", systemImage: "star")
                            }
                            Button(action: { store.send(.navigateToSettings) }) {
                                Label("설정", systemImage: "gear")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
        } destination: { store in
            switch store.case {
            case let .search(store):
                SearchView(store: store)
            case let .restaurantDetail(store):
                RestaurantDetailView(store: store)
            case let .favorite(store):
                FavoriteView(store: store)
            case let .settings(store):
                SettingsView(store: store)
            }
        }
    }
} 