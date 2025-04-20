import Moya

extension MoyaProvider {
    static var `default`: MoyaProvider<Target> {
        return MoyaProvider<Target>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
    }
}

extension MoyaProvider {
    func asyncRequest(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
