import ComposableArchitecture

private enum ShopRepositoryKey: DependencyKey {
    static let liveValue: ShopRepository = ShopRepositoryImpl(
        remoteDataSource: ShopRemoteDataSourceImpl()
    )
}

extension DependencyValues {
    var shopRepository: ShopRepository {
        get { self[ShopRepositoryKey.self] }
        set { self[ShopRepositoryKey.self] = newValue }
    }
}
