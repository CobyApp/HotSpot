import SwiftUI
import UIKit
import ComposableArchitecture

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = CustomNavigationController()
    }
    
    func start() {
        let mapView = MapView(
            store: Store(
                initialState: MapStore.State(),
                reducer: { MapStore() }
            )
        )
        .environment(\.coordinator, self)
        
        let hostingController = UIHostingController(rootView: mapView)
        navigationController.viewControllers = [hostingController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showSearch() {
        let searchView = SearchView(
            store: Store(
                initialState: SearchStore.State(),
                reducer: { SearchStore() }
            )
        )
        .environment(\.coordinator, self)
        
        push(searchView)
    }
    
    func showShopDetail(_ shop: ShopModel) {
        let shopDetailView = ShopDetailView(
            store: Store(
                initialState: ShopDetailStore.State(shop: shop),
                reducer: { ShopDetailStore() }
            )
        )
        .environment(\.coordinator, self)
        
        push(shopDetailView)
    }
    
    private func push<Content: View>(_ view: Content, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
} 
