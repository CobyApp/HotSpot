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
        var isFilterSheetPresented: Bool = false
        
        // Filter states
        var selectedBudget: Int = 0
        var hasWiFi: Bool = false
        var hasPrivateRoom: Bool = false
        var isNonSmoking: Bool = false
        var hasParking: Bool = false
        var selectedCuisine: Int = 0
        var selectedDistance: Int = 3
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.shops == rhs.shops &&
            lhs.searchText == rhs.searchText &&
            lhs.error == rhs.error &&
            lhs.currentLocation?.latitude == rhs.currentLocation?.latitude &&
            lhs.currentLocation?.longitude == rhs.currentLocation?.longitude &&
            lhs.selectedShop == rhs.selectedShop &&
            lhs.paginationState.currentPage == rhs.paginationState.currentPage &&
            lhs.paginationState.isLastPage == rhs.paginationState.isLastPage &&
            lhs.paginationState.isLoading == rhs.paginationState.isLoading &&
            lhs.isFilterSheetPresented == rhs.isFilterSheetPresented &&
            lhs.selectedBudget == rhs.selectedBudget &&
            lhs.hasWiFi == rhs.hasWiFi &&
            lhs.hasPrivateRoom == rhs.hasPrivateRoom &&
            lhs.isNonSmoking == rhs.isNonSmoking &&
            lhs.hasParking == rhs.hasParking &&
            lhs.selectedCuisine == rhs.selectedCuisine &&
            lhs.selectedDistance == rhs.selectedDistance
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
        
        // Filter actions
        case toggleFilterSheet
        case updateBudget(Int)
        case toggleWiFi
        case togglePrivateRoom
        case toggleNonSmoking
        case toggleParking
        case updateCuisine(Int)
        case updateDistance(Int)
        case resetFilters
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

            case let .search(text):
                guard text != state.searchText else { return .none }
                
                state.searchText = text
                state.paginationState.reset()
                print("Search started - text: \(text)")
                
                return .run { [state] send in
                    do {
                        let location = state.currentLocation ?? CLLocationCoordinate2D(latitude: 34.6937, longitude: 135.5023)
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: state.selectedDistance,
                            count: nil,
                            keyword: text,
                            genre: state.selectedCuisine > 0 ? String(state.selectedCuisine) : nil,
                            order: nil,
                            start: nil,
                            budget: state.selectedBudget > 0 ? String(state.selectedBudget) : nil,
                            privateRoom: state.hasPrivateRoom ? true : nil,
                            wifi: state.hasWiFi ? true : nil,
                            nonSmoking: state.isNonSmoking ? true : nil,
                            coupon: nil,
                            openNow: nil
                        )
                        
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            request: request,
                            currentPage: 1
                        )
                        
                        print("Search result - currentPage: \(result.currentPage), hasMore: \(result.hasMore), shops count: \(result.shops.count)")
                        
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
                guard !state.paginationState.isLoading && !state.paginationState.isLastPage else {
                    print("LoadMore skipped - isLoading: \(state.paginationState.isLoading), isLastPage: \(state.paginationState.isLastPage), currentPage: \(state.paginationState.currentPage)")
                    return .none
                }
                
                state.paginationState.startLoading()
                print("Loading more - currentPage: \(state.paginationState.currentPage)")
                
                return .run { [state] send in
                    do {
                        let location = state.currentLocation ?? CLLocationCoordinate2D(latitude: 34.6937, longitude: 135.5023)
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: state.selectedDistance,
                            count: nil,
                            keyword: state.searchText,
                            genre: state.selectedCuisine > 0 ? String(state.selectedCuisine) : nil,
                            order: nil,
                            start: nil,
                            budget: state.selectedBudget > 0 ? String(state.selectedBudget) : nil,
                            privateRoom: state.hasPrivateRoom ? true : nil,
                            wifi: state.hasWiFi ? true : nil,
                            nonSmoking: state.isNonSmoking ? true : nil,
                            coupon: nil,
                            openNow: nil
                        )
                        
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            request: request,
                            currentPage: state.paginationState.currentPage,
                            isLoadMore: true
                        )
                        
                        print("LoadMore result - currentPage: \(result.currentPage), hasMore: \(result.hasMore), shops count: \(result.shops.count)")
                        
                        // Create a Set of existing shop IDs for quick lookup
                        let existingShopIds = Set(state.shops.map { $0.id })
                        // Filter out any shops that are already in the list
                        let newShops = result.shops.filter { !existingShopIds.contains($0.id) }
                        
                        await send(.updateShops(state.shops + newShops))
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
                print("PaginationState updated - currentPage: \(newState.currentPage), isLastPage: \(newState.isLastPage), isLoading: \(newState.isLoading)")
                return .none
                
            // Filter actions
            case .toggleFilterSheet:
                state.isFilterSheetPresented.toggle()
                return .none
                
            case let .updateBudget(budget):
                state.selectedBudget = budget
                return .none
                
            case .toggleWiFi:
                state.hasWiFi.toggle()
                return .none
                
            case .togglePrivateRoom:
                state.hasPrivateRoom.toggle()
                return .none
                
            case .toggleNonSmoking:
                state.isNonSmoking.toggle()
                return .none
                
            case .toggleParking:
                state.hasParking.toggle()
                return .none
                
            case let .updateCuisine(cuisine):
                state.selectedCuisine = cuisine
                return .none
                
            case let .updateDistance(distance):
                state.selectedDistance = distance
                return .none
                
            case .resetFilters:
                state.selectedBudget = 0
                state.hasWiFi = false
                state.hasPrivateRoom = false
                state.isNonSmoking = false
                state.hasParking = false
                state.selectedCuisine = 0
                state.selectedDistance = 3
                return .none
            }
        }
    }
} 
