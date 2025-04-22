import Foundation
import ComposableArchitecture
import Data

public enum ShopRepositoryKey: DependencyKey {
    public static let liveValue: ShopRepository = ShopRepositoryImpl(
        remoteDataSource: ShopRemoteDataSourceImpl()
    )
}

public extension DependencyValues {
    var shopRepository: ShopRepository {
        get { self[ShopRepositoryKey.self] }
        set { self[ShopRepositoryKey.self] = newValue }
    }
}
