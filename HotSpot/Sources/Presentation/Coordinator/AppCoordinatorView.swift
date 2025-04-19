import SwiftUI
import ComposableArchitecture

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>
    
    var body: some View {
        CustomNavigationView(store: store)
    }
}

#Preview {
    AppCoordinatorView(
        store: Store(
            initialState: AppCoordinator.State(),
            reducer: { AppCoordinator() }
        )
    )
}
