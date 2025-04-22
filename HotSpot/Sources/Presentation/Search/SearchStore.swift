import Foundation
import CoreLocation
import ComposableArchitecture

@Reducer
struct SearchStore {
    @Dependency(\.shopRepository) var shopRepository
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var shops: [ShopModel] = []
        var searchText: String = ""
        var error: ShopError? = nil
        var paginationState: PaginationState = .init()
    }

    enum Action {
        case onAppear
        case search(String)
        case updateShops([ShopModel])
        case handleError(Error)
        case clearError
        case loadMore
        case updatePaginationState(PaginationState)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.search(""))
                }

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
                
                return .run { send in
                    do {
                        let request = ShopSearchRequestDTO(
                            lat: userDefaults.location.latitude,
                            lng: userDefaults.location.longitude,
                            range: userDefaults.range,
                            count: nil,
                            name: text,
                            genres: !userDefaults.genres.isEmpty ? userDefaults.genres : nil,
                            start: nil,
                            budgets: !userDefaults.budgets.isEmpty ? userDefaults.budgets : nil,
                            privateRoom: userDefaults.privateRoom,
                            wifi: userDefaults.wifi,
                            nonSmoking: userDefaults.nonSmoking,
                            parking: userDefaults.parking
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
                        let location = userDefaults.location
                        let request = ShopSearchRequestDTO(
                            lat: location.latitude,
                            lng: location.longitude,
                            range: userDefaults.range,
                            count: nil,
                            name: state.searchText,
                            genres: !userDefaults.genres.isEmpty ? userDefaults.genres : nil,
                            start: nil,
                            budgets: !userDefaults.budgets.isEmpty ? userDefaults.budgets : nil,
                            privateRoom: userDefaults.privateRoom,
                            wifi: userDefaults.wifi,
                            nonSmoking: userDefaults.nonSmoking,
                            parking: userDefaults.parking
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
            }
        }
    }
}
