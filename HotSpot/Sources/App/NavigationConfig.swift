import SwiftUI
import UIKit

extension UINavigationBar {
    static func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().isTranslucent = true
    }
}

struct NavigationControllerKey: EnvironmentKey {
    static let defaultValue: UINavigationController = UINavigationController()
}

extension EnvironmentValues {
    var navigationController: UINavigationController {
        get { self[NavigationControllerKey.self] }
        set { self[NavigationControllerKey.self] = newValue }
    }
} 