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
        var selectedShop: ShopModel? = nil
        var paginationState: PaginationState = .init()
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.shops == rhs.shops &&
            lhs.searchText == rhs.searchText &&
            lhs.error == rhs.error &&
            lhs.currentLocation?.latitude == rhs.currentLocation?.latitude &&
            lhs.currentLocation?.longitude == rhs.currentLocation?.longitude &&
            lhs.selectedShop == rhs.selectedShop &&
            lhs.paginationState.currentPage == rhs.paginationState.currentPage &&
            lhs.paginationState.isLastPage == rhs.paginationState.isLastPage &&
            lhs.paginationState.isLoading == rhs.paginationState.isLoading
        }
    }

    enum Action {
        case onAppear
        case search(String)
        case selectShop(ShopModel)
        case pop
        case updateLocation(CLLocationCoordinate2D)
        case updateShops([ShopModel])
        case handleError(Error)
        case loadMore
        case updatePaginationState(PaginationState)
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

            case let .selectShop(shop):
                state.selectedShop = shop
                return .none

            case .pop:
                return .none

            case .loadMore:
                guard !state.paginationState.isLoading && !state.paginationState.isLastPage else {
                    return .none
                }
                
                state.paginationState.startLoading()
                
                return .run { [state] send in
                    do {
                        let location = state.currentLocation ?? CLLocationCoordinate2D(latitude: 34.6937, longitude: 135.5023)
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: 5,
                            count: nil,
                            keyword: state.searchText,
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
                        
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            request: request,
                            currentPage: state.paginationState.currentPage,
                            isLoadMore: true
                        )
                        
                        await send(.updateShops(state.shops + result.shops))
                        await send(.updatePaginationState(PaginationState(
                            currentPage: result.currentPage,
                            isLastPage: !result.hasMore,
                            isLoading: false
                        )))
                    } catch {
                        await send(.handleError(error))
                        await send(.updatePaginationState(PaginationState(
                            currentPage: state.paginationState.currentPage,
                            isLastPage: state.paginationState.isLastPage,
                            isLoading: false
                        )))
                    }
                }
                
            case let .updatePaginationState(newState):
                state.paginationState = newState
                return .none

            case let .search(text):
                state.searchText = text
                state.paginationState.reset()
                
                return .run { [state] send in
                    do {
                        let location = state.currentLocation ?? CLLocationCoordinate2D(latitude: 34.6937, longitude: 135.5023)
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: 5,
                            count: nil,
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
                        
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            request: request,
                            currentPage: 1
                        )
                        
                        await send(.updateShops(result.shops))
                        await send(.updatePaginationState(PaginationState(
                            currentPage: result.currentPage,
                            isLastPage: !result.hasMore,
                            isLoading: false
                        )))
                    } catch {
                        await send(.handleError(error))
                    }
                }
            }
        }
    }
} 
