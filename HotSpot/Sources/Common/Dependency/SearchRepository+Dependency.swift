import ComposableArchitecture

private enum SearchRepositoryKey: DependencyKey {
    static let liveValue: SearchRepository = SearchRepositoryImpl(
        remoteDataSource: ShopRemoteDataSourceImpl()
    )
}

extension DependencyValues {
    var searchRepository: SearchRepository {
        get { self[SearchRepositoryKey.self] }
        set { self[SearchRepositoryKey.self] = newValue }
    }
} 