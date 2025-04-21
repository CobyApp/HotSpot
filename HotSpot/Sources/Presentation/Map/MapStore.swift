import Foundation
import CoreLocation
import ComposableArchitecture
import MapKit

@Reducer
struct MapStore {
    @Dependency(\.shopRepository) var shopRepository

    struct State: Equatable {
        var shops: [ShopModel] = []
        var visibleShops: [ShopModel] = []
        var region: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        var error: String? = nil
        var lastFetchedLocation: CLLocationCoordinate2D? = nil
    }

    enum Action {
        case updateRegion(MKCoordinateRegion)
        case fetchShops
        case updateShops([ShopModel])
        case handleError(Error)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateRegion(region):
                state.region = region

                if shouldFetchNewData(state: state, newRegion: region) {
                    state.lastFetchedLocation = region.center
                    return .send(.fetchShops)
                }

                state.visibleShops = filterVisibleShops(state.shops, in: region)
                return .none

            case .fetchShops:
                return .run { [region = state.region] send in
                    do {
                        let useCase = ShopsUseCase(repository: shopRepository)
                        let shops = try await useCase.execute(
                            lat: region.center.latitude,
                            lng: region.center.longitude
                        )
                        await send(.updateShops(shops))
                    } catch {
                        await send(.handleError(error))
                    }
                }

            case let .updateShops(shops):
                state.shops = shops
                state.visibleShops = filterVisibleShops(shops, in: state.region)
                return .none

            case let .handleError(error):
                state.error = error.localizedDescription
                return .none
            }
        }
    }

    // MARK: - Helpers
    func shouldFetchNewData(state: State, newRegion: MKCoordinateRegion) -> Bool {
        guard let lastLocation = state.lastFetchedLocation else {
            return true
        }

        let distance = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
            .distance(from: CLLocation(latitude: newRegion.center.latitude, longitude: newRegion.center.longitude))

        return distance > 100
    }

    func filterVisibleShops(_ shops: [ShopModel], in region: MKCoordinateRegion) -> [ShopModel] {
        shops.filter { shop in
            let coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
            let latMin = region.center.latitude - region.span.latitudeDelta / 2
            let latMax = region.center.latitude + region.span.latitudeDelta / 2
            let lonMin = region.center.longitude - region.span.longitudeDelta / 2
            let lonMax = region.center.longitude + region.span.longitudeDelta / 2
            
            return coordinate.latitude >= latMin &&
                   coordinate.latitude <= latMax &&
                   coordinate.longitude >= lonMin &&
                   coordinate.longitude <= lonMax
        }
    }
}

// MARK: - Equatable
extension MapStore.State {
    static func == (lhs: MapStore.State, rhs: MapStore.State) -> Bool {
        lhs.shops == rhs.shops &&
        lhs.visibleShops == rhs.visibleShops &&
        lhs.region.center.latitude == rhs.region.center.latitude &&
        lhs.region.center.longitude == rhs.region.center.longitude &&
        lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
        lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta &&
        lhs.error == rhs.error &&
        lhs.lastFetchedLocation?.latitude == rhs.lastFetchedLocation?.latitude &&
        lhs.lastFetchedLocation?.longitude == rhs.lastFetchedLocation?.longitude
    }
}
