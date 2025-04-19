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
        var selectedShop: ShopModel? = nil
        var region: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        var error: String? = nil
        var lastFetchedLocation: CLLocationCoordinate2D? = nil
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case fetchShops
        case showSearch
        case showShopDetail(ShopModel)
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

            case let .updateRegion(region):
                state.region = region
                
                if shouldFetchNewData(state: state, newRegion: region) {
                    state.lastFetchedLocation = region.center
                    return .run { send in
                        await send(.fetchShops)
                    }
                }

                state.visibleShops = filterVisibleShops(state.shops, in: region)
                return .none

            case .fetchShops:
                return .run { [state] send in
                    do {
                        let request = createSearchRequest(for: state.region)
                        let shops = try await shopRepository.searchShops(request: request)
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

            case .showSearch:
                return .none

            case let .showShopDetail(shop):
                state.selectedShop = shop
                return .none
            }
        }
    }
}

// MARK: - Private Helpers
private extension MapStore {
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
            region.contains(CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude))
        }
    }
    
    func createSearchRequest(for region: MKCoordinateRegion) -> ShopSearchRequestDTO {
        ShopSearchRequestDTO(
            lat: region.center.latitude,
            lng: region.center.longitude,
            range: 5,
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
    }
}

// MARK: - Equatable
extension MapStore.State {
    static func == (lhs: MapStore.State, rhs: MapStore.State) -> Bool {
        lhs.shops == rhs.shops &&
        lhs.visibleShops == rhs.visibleShops &&
        lhs.selectedShop == rhs.selectedShop &&
        lhs.region.center.latitude == rhs.region.center.latitude &&
        lhs.region.center.longitude == rhs.region.center.longitude &&
        lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
        lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta &&
        lhs.error == rhs.error &&
        lhs.lastFetchedLocation?.latitude == rhs.lastFetchedLocation?.latitude &&
        lhs.lastFetchedLocation?.longitude == rhs.lastFetchedLocation?.longitude
    }
}
