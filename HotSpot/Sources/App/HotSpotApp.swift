import SwiftUI
import ComposableArchitecture

@main
struct HotSpotApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MapView(
                    store: Store(
                        initialState: MapStore.State(),
                        reducer: { MapStore() }
                    )
                )
            }
        }
    }
} 