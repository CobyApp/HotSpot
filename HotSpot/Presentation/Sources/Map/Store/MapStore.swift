import Foundation
import CoreLocation
import ComposableArchitecture
import MapKit
import Domain

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
    }

    enum Action: Equatable {
        case updateRegion(MapRegion)
        case fetchShops
        case updateShops([ShopModel])
        case handleError(ShopError)
        case clearError
    }

    enum CancelID { case fetchShops }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            case let .updateRegion(region):
                state.region = region
                state.visibleShops = ShopModel.filterVisibleShops(state.shops, in: region)
                state.lastFetchedLocation = region.center
                return .send(.fetchShops)

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
                .cancellable(id: CancelID.fetchShops, cancelInFlight: true)

            case let .updateShops(shops):
                state.shops = shops
                state.visibleShops = ShopModel.filterVisibleShops(shops, in: state.region)
                return .none

            case let .handleError(error):
                state.error = error
                return .none

            case .clearError:
                state.error = nil
                return .none
            }
        }
    }
}
