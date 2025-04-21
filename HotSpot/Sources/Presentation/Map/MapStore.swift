import Foundation
import CoreLocation
import ComposableArchitecture
import MapKit

struct MapStore: Reducer {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        var shops: [ShopModel] = []
        var visibleShops: [ShopModel] = []
        var region: MapRegion = MapRegion(
            center: MapCoordinate(latitude: 35.6762, longitude: 139.6503),
            span: MapSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        var lastFetchedLocation: MapCoordinate? = nil
        var error: ShopError? = nil
        var shouldShowNoShopsMessage: Bool = false
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.shops == rhs.shops &&
            lhs.visibleShops == rhs.visibleShops &&
            lhs.region.center.latitude == rhs.region.center.latitude &&
            lhs.region.center.longitude == rhs.region.center.longitude &&
            lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
            lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta &&
            lhs.lastFetchedLocation?.latitude == rhs.lastFetchedLocation?.latitude &&
            lhs.lastFetchedLocation?.longitude == rhs.lastFetchedLocation?.longitude &&
            lhs.error == rhs.error &&
            lhs.shouldShowNoShopsMessage == rhs.shouldShowNoShopsMessage
        }
    }

    enum Action: Equatable {
        case updateRegion(MapRegion)
        case fetchShops
        case updateShops([ShopModel])
        case handleError(ShopError)
        case clearError
        case clearNoShopsMessage
        
        static func == (lhs: Action, rhs: Action) -> Bool {
            switch (lhs, rhs) {
            case let (.updateRegion(lRegion), .updateRegion(rRegion)):
                return lRegion.center.latitude == rRegion.center.latitude &&
                       lRegion.center.longitude == rRegion.center.longitude &&
                       lRegion.span.latitudeDelta == rRegion.span.latitudeDelta &&
                       lRegion.span.longitudeDelta == rRegion.span.longitudeDelta
            case (.fetchShops, .fetchShops):
                return true
            case let (.updateShops(lShops), .updateShops(rShops)):
                return lShops == rShops
            case let (.handleError(lError), .handleError(rError)):
                return lError == rError
            case (.clearError, .clearError):
                return true
            case (.clearNoShopsMessage, .clearNoShopsMessage):
                return true
            default:
                return false
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateRegion(region):
                state.region = region
                state.visibleShops = ShopModel.filterVisibleShops(state.shops, in: region)
                state.lastFetchedLocation = region.center
                return .run { send in
                    try await Task.sleep(nanoseconds: 500_000_000)
                    await send(.fetchShops)
                }
                .cancellable(id: CancelID.fetchShops, cancelInFlight: true)

            case .fetchShops:
                let lat = state.region.center.latitude
                let lng = state.region.center.longitude

                return .run { send in
                    do {
                        let useCase = ShopsUseCase(repository: shopRepository)
                        let shops = try await useCase.execute(lat: lat, lng: lng)
                        await send(.updateShops(shops))
                    } catch let error as ShopError {
                        await send(.handleError(error))
                    } catch {
                        await send(.handleError(.server(message: error.localizedDescription)))
                    }
                }

            case let .updateShops(shops):
                state.shops = shops
                state.visibleShops = ShopModel.filterVisibleShops(shops, in: state.region)
                state.shouldShowNoShopsMessage = state.visibleShops.isEmpty
                return .none

            case let .handleError(error):
                state.error = error
                return .none

            case .clearError:
                state.error = nil
                return .none

            case .clearNoShopsMessage:
                state.shouldShowNoShopsMessage = false
                return .none
            }
        }
    }

    enum CancelID { case fetchShops }
}
