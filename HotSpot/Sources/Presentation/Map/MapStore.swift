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
        var selectedShopId: String? = nil
        var region: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        var isInitialized: Bool = false
        var error: String? = nil
        var lastFetchedLocation: CLLocationCoordinate2D? = nil

        static func == (lhs: State, rhs: State) -> Bool {
            lhs.shops == rhs.shops &&
            lhs.visibleShops == rhs.visibleShops &&
            lhs.selectedShopId == rhs.selectedShopId &&
            lhs.region.center.latitude == rhs.region.center.latitude &&
            lhs.region.center.longitude == rhs.region.center.longitude &&
            lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
            lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta &&
            lhs.isInitialized == rhs.isInitialized &&
            lhs.error == rhs.error &&
            lhs.lastFetchedLocation?.latitude == rhs.lastFetchedLocation?.latitude &&
            lhs.lastFetchedLocation?.longitude == rhs.lastFetchedLocation?.longitude
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case fetchShops
        case showSearch
        case showShopDetail(String)
        case updateRegion(MKCoordinateRegion)
        case updateShops([ShopModel])
        case handleError(Error)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                state.lastFetchedLocation = state.region.center
                return .run { send in
                    await send(.fetchShops)
                }

            case let .updateRegion(region):
                state.region = region
                
                // Check if we need to fetch new data based on distance
                if let lastLocation = state.lastFetchedLocation {
                    let distance = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
                        .distance(from: CLLocation(latitude: region.center.latitude, longitude: region.center.longitude))
                    
                    // Only fetch if moved more than 100 meters
                    if distance > 100 {
                        state.lastFetchedLocation = region.center
                        return .run { send in
                            await send(.fetchShops)
                        }
                    }
                } else {
                    state.lastFetchedLocation = region.center
                    return .run { send in
                        await send(.fetchShops)
                    }
                }

                // Filter visible shops based on region
                let northEast = CLLocationCoordinate2D(
                    latitude: region.center.latitude + region.span.latitudeDelta / 2,
                    longitude: region.center.longitude + region.span.longitudeDelta / 2
                )
                let southWest = CLLocationCoordinate2D(
                    latitude: region.center.latitude - region.span.latitudeDelta / 2,
                    longitude: region.center.longitude - region.span.longitudeDelta / 2
                )

                state.visibleShops = state.shops.filter { shop in
                    shop.latitude <= northEast.latitude &&
                    shop.latitude >= southWest.latitude &&
                    shop.longitude <= northEast.longitude &&
                    shop.longitude >= southWest.longitude
                }
                return .none

            case .fetchShops:
                return .run { [state] send in
                    do {
                        let request = ShopSearchRequestDTO(
                            lat: state.region.center.latitude,
                            lng: state.region.center.longitude,
                            range: 5,  // Fixed range
                            count: 100,
                            keyword: nil,
                            genre: nil,
                            order: nil,
                            start: nil,
                            budget: nil,
                            privateRoom: nil,
                            wifi: nil,
                            nonSmoking: nil,
                            coupon: nil,
                            openNow: nil
                        )
                        let shops = try await shopRepository.searchShops(request: request)
                        await send(.updateShops(shops))
                    } catch {
                        await send(.handleError(error))
                    }
                }

            case let .updateShops(shops):
                state.shops = shops
                // Filter visible shops based on current region
                let northEast = CLLocationCoordinate2D(
                    latitude: state.region.center.latitude + state.region.span.latitudeDelta / 2,
                    longitude: state.region.center.longitude + state.region.span.longitudeDelta / 2
                )
                let southWest = CLLocationCoordinate2D(
                    latitude: state.region.center.latitude - state.region.span.latitudeDelta / 2,
                    longitude: state.region.center.longitude - state.region.span.longitudeDelta / 2
                )

                state.visibleShops = shops.filter { shop in
                    shop.latitude <= northEast.latitude &&
                    shop.latitude >= southWest.latitude &&
                    shop.longitude <= northEast.longitude &&
                    shop.longitude >= southWest.longitude
                }
                return .none

            case let .handleError(error):
                state.error = error.localizedDescription
                return .none

            case .showSearch:
                return .none

            case let .showShopDetail(id):
                state.selectedShopId = id
                return .none
            }
        }
    }
}
