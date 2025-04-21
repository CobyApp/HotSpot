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
        var error: ShopError? = nil
        var currentLocation: CLLocationCoordinate2D?
        var paginationState: PaginationState = .init()
        
        var filterState: SearchFilterStore.State = .init()
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.shops == rhs.shops &&
            lhs.searchText == rhs.searchText &&
            lhs.error == rhs.error &&
            lhs.currentLocation?.latitude == rhs.currentLocation?.latitude &&
            lhs.currentLocation?.longitude == rhs.currentLocation?.longitude &&
            lhs.paginationState == rhs.paginationState &&
            lhs.filterState == rhs.filterState
        }
    }

    enum Action {
        case onAppear
        case search(String)
        case updateLocation(CLLocationCoordinate2D)
        case updateShops([ShopModel])
        case handleError(Error)
        case clearError
        case loadMore
        case updatePaginationState(PaginationState)
        case updateFilterState(SearchFilterStore.State)
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
                switch error {
                case is URLError:
                    state.error = .network
                case is DecodingError:
                    state.error = .decoding
                default:
                    state.error = .server(message: error.localizedDescription)
                }
                return .none
                
            case .clearError:
                state.error = nil
                return .none

            case let .search(text):
                guard text != state.searchText else { return .none }
                
                state.searchText = text
                state.paginationState.reset()
                
                return .run { [state] send in
                    do {
                        let location = state.currentLocation ?? CLLocationCoordinate2D(latitude: 34.6937, longitude: 135.5023)
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: state.filterState.selectedDistance,
                            count: nil,
                            keyword: text,
                            genre: state.filterState.selectedCuisine > 0 ? String(state.filterState.selectedCuisine) : nil,
                            order: nil,
                            start: nil,
                            budget: state.filterState.selectedBudget > 0 ? String(state.filterState.selectedBudget) : nil,
                            privateRoom: state.filterState.hasPrivateRoom ? true : nil,
                            wifi: state.filterState.hasWiFi ? true : nil,
                            nonSmoking: state.filterState.isNonSmoking ? true : nil,
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

            case .loadMore:
                return .run { [state] send in
                    do {
                        let location = state.currentLocation ?? CLLocationCoordinate2D(latitude: 34.6937, longitude: 135.5023)
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: state.filterState.selectedDistance,
                            count: nil,
                            keyword: state.searchText,
                            genre: state.filterState.selectedCuisine > 0 ? String(state.filterState.selectedCuisine) : nil,
                            order: nil,
                            start: nil,
                            budget: state.filterState.selectedBudget > 0 ? String(state.filterState.selectedBudget) : nil,
                            privateRoom: state.filterState.hasPrivateRoom ? true : nil,
                            wifi: state.filterState.hasWiFi ? true : nil,
                            nonSmoking: state.filterState.isNonSmoking ? true : nil,
                            coupon: nil,
                            openNow: nil
                        )
                        
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            request: request,
                            currentPage: state.paginationState.currentPage,
                            isLoadMore: true
                        )
                        
                        let existingShopIds = Set(state.shops.map { $0.id })
                        let newShops = result.shops.filter { !existingShopIds.contains($0.id) }
                        
                        await send(.updateShops(state.shops + newShops))
                        await send(.updatePaginationState(PaginationState(
                            currentPage: result.currentPage,
                            isLastPage: !result.hasMore,
                            isLoading: false
                        )))
                    } catch {
                        await send(.handleError(error))
                    }
                }

            case let .updatePaginationState(paginationState):
                state.paginationState = paginationState
                return .none
                
            case let .updateFilterState(filterState):
                state.filterState = filterState
                return .run { [state] send in
                    await send(.search(state.searchText))
                }
            }
        }
    }
}
