import SwiftUI
import UIKit
import ComposableArchitecture

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var errorAlertController: UIAlertController?
    
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
    
    func showError(_ error: ShopError) {
        let errorMessage = ShopErrorMessageMapper.message(for: error)
        showErrorAlert(message: errorMessage)
    }
    
    private func showErrorAlert(message: String) {
        errorAlertController?.dismiss(animated: false)
        
        let alert = UIAlertController(
            title: "エラー",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { [weak self] _ in
                self?.errorAlertController = nil
            }
        ))
        
        errorAlertController = alert
        navigationController.present(alert, animated: true)
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
    
    func showSearchFilter() {
        let searchFilterView = SearchFilterView(
            store: Store(
                initialState: SearchFilterStore.State(),
                reducer: { SearchFilterStore() }
            )
        )
        .environment(\.coordinator, self)
        
        push(searchFilterView)
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
