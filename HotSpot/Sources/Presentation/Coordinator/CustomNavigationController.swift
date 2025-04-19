import SwiftUI
import UIKit
import ComposableArchitecture
import Combine

final class CustomNavigationController: UINavigationController {
    private let store: StoreOf<AppCoordinator>
    private var viewStore: ViewStore<AppCoordinator.State, AppCoordinator.Action>
    
    init(store: StoreOf<AppCoordinator>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        super.init(nibName: nil, bundle: nil)
        setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigation() {
        let mapView = MapView(store: store.scope(state: \.map, action: \.map))
        let mapHostingController = UIHostingController(rootView: mapView)
        setViewControllers([mapHostingController], animated: false)
        
        // Observe state changes
        viewStore.publisher
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func handleStateChange(_ state: AppCoordinator.State) {
        // Handle search presentation
        if let searchState = state.search {
            let searchStore = store.scope(
                state: { _ in searchState },
                action: { .search($0) }
            )
            let searchView = SearchView(store: searchStore)
            let searchHostingController = UIHostingController(rootView: searchView)
            pushViewController(searchHostingController, animated: true)
        } else {
            if viewControllers.contains(where: { $0 is UIHostingController<SearchView> }) {
                popViewController(animated: true)
            }
        }
        
        // Handle shop detail presentation
        if let shopDetailState = state.shopDetail {
            let shopDetailStore = store.scope(
                state: { _ in shopDetailState },
                action: { .shopDetail($0) }
            )
            let shopDetailView = ShopDetailView(store: shopDetailStore)
            let shopDetailHostingController = UIHostingController(rootView: shopDetailView)
            pushViewController(shopDetailHostingController, animated: true)
        } else {
            if viewControllers.contains(where: { $0 is UIHostingController<ShopDetailView> }) {
                popViewController(animated: true)
            }
        }
    }
}

// SwiftUI wrapper
struct CustomNavigationView: UIViewControllerRepresentable {
    let store: StoreOf<AppCoordinator>
    
    func makeUIViewController(context: Context) -> CustomNavigationController {
        CustomNavigationController(store: store)
    }
    
    func updateUIViewController(_ uiViewController: CustomNavigationController, context: Context) {
        // Update logic if needed
    }
} 