import SwiftUI
import UIKit
import ComposableArchitecture

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var errorAlertController: UIAlertController?
    private var messageAlertController: UIAlertController?
    
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
        showAlert(title: "エラー", message: errorMessage)
    }
    
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    private func showAlert(title: String, message: String) {
        // 이미 표시된 알림이 있다면 제거
        errorAlertController?.dismiss(animated: false)
        messageAlertController?.dismiss(animated: false)
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { [weak self] _ in
                self?.errorAlertController = nil
                self?.messageAlertController = nil
            }
        ))
        
        if title == "エラー" {
            errorAlertController = alert
        } else {
            messageAlertController = alert
        }
        
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
