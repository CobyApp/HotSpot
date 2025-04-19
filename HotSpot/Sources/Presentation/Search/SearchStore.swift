import Foundation
import CoreLocation
import ComposableArchitecture

@Reducer
struct SearchStore {
    @Dependency(\.shopRepository) var shopRepository
    @Dependency(\.locationManager) var locationManager

    struct State: Equatable {
        var shops: [ShopModel] = []
        var searchText: String = ""
        var error: String? = nil
        var currentLocation: CLLocationCoordinate2D?
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.shops == rhs.shops &&
            lhs.searchText == rhs.searchText &&
            lhs.error == rhs.error &&
            lhs.currentLocation?.latitude == rhs.currentLocation?.latitude &&
            lhs.currentLocation?.longitude == rhs.currentLocation?.longitude
        }
    }

    enum Action {
        case onAppear
        case search(String)
        case showShopDetail(ShopModel)
        case pop
        case updateLocation(CLLocationCoordinate2D)
        case updateShops([ShopModel])
        case handleError(Error)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    if let location = await locationManager.requestLocation() {
                        await send(.updateLocation(location.coordinate))
                    }
                }

            case let .updateLocation(location):
                state.currentLocation = location
                return .none

            case let .updateShops(shops):
                state.shops = shops
                return .none

            case let .handleError(error):
                state.error = error.localizedDescription
                return .none

            case .showShopDetail:
                return .none

            case .pop:
                return .none

            case let .search(text):
                guard let location = state.currentLocation else { return .none }
                
                return .run { send in
                    do {
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: 5,
                            count: 100,
                            keyword: text,
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
            }
        }
    }
} 
