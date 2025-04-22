import Foundation
import CoreLocation
import ComposableArchitecture
import Domain

@Reducer
public struct SearchStore {
    @Dependency(\.shopRepository) var shopRepository
    @Dependency(\.userDefaults) var userDefaults

    public struct State: Equatable {
        public var shops: [ShopModel] = []
        public var searchText: String = ""
        public var error: ShopError? = nil
        public var currentPage: Int = 1
        public var isLastPage: Bool = false
        
        public init() {}
    }

    public enum Action {
        case search
        case updateSearchText(String)
        case updateShops([ShopModel])
        case handleError(Error)
        case clearError
        case loadMore
        case updatePage(Int, Bool)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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

            case let .updateSearchText(text):
                state.searchText = text
                return .none

            case .search:
                state.currentPage = 1
                state.isLastPage = false
                
                return .run { [state] send in
                    do {
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            latitude: userDefaults.location.latitude,
                            longitude: userDefaults.location.longitude,
                            range: userDefaults.range,
                            name: state.searchText.isEmpty ? nil : state.searchText,
                            genres: !userDefaults.genres.isEmpty ? userDefaults.genres : nil,
                            budgets: !userDefaults.budgets.isEmpty ? userDefaults.budgets : nil,
                            privateRoom: userDefaults.privateRoom,
                            wifi: userDefaults.wifi,
                            nonSmoking: userDefaults.nonSmoking,
                            parking: userDefaults.parking,
                            currentPage: 1
                        )
                        
                        await send(.updateShops(result.shops))
                        await send(.updatePage(result.currentPage, !result.hasMore))
                    } catch {
                        await send(.handleError(error))
                    }
                }

            case .loadMore:
                if state.isLastPage { return .none }
                
                return .run { [state] send in
                    do {
                        let location = userDefaults.location
                        let useCase = InfiniteScrollSearchUseCase(repository: shopRepository)
                        let result = try await useCase.execute(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            range: userDefaults.range,
                            name: state.searchText.isEmpty ? nil : state.searchText,
                            genres: !userDefaults.genres.isEmpty ? userDefaults.genres : nil,
                            budgets: !userDefaults.budgets.isEmpty ? userDefaults.budgets : nil,
                            privateRoom: userDefaults.privateRoom,
                            wifi: userDefaults.wifi,
                            nonSmoking: userDefaults.nonSmoking,
                            parking: userDefaults.parking,
                            currentPage: state.currentPage,
                            isLoadMore: true
                        )
                        
                        let existingShopIds = Set(state.shops.map { $0.id })
                        let newShops = result.shops.filter { !existingShopIds.contains($0.id) }
                        
                        await send(.updateShops(state.shops + newShops))
                        await send(.updatePage(result.currentPage, !result.hasMore))
                    } catch {
                        await send(.handleError(error))
                    }
                }

            case let .updatePage(page, isLastPage):
                state.currentPage = page
                state.isLastPage = isLastPage
                return .none
            }
        }
    }
}
