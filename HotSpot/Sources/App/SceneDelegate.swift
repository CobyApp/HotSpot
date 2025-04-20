import SwiftUI
import UIKit
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UINavigationBar.configureAppearance()
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = CustomNavigationController()
        
        let mapView = MapView(
            store: Store(
                initialState: MapStore.State(),
                reducer: { MapStore() }
            )
        )
        
        let hostingController = UIHostingController(rootView: mapView)
        navigationController.viewControllers = [hostingController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
} 