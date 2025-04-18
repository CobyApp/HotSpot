import SwiftUI
import ComposableArchitecture

@main
struct HotSpotApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(
                store: Store(
                    initialState: AppCoordinator.State(),
                    reducer: { AppCoordinator() }
                )
            )
        }
    }
} 