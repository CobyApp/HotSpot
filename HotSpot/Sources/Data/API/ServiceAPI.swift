import Foundation
import Moya

enum ServiceAPI {
    case searchShops(ShopSearchRequestDTO)
}

extension ServiceAPI: TargetType {
    var baseURL: URL {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let url = URL(string: baseURLString) else {
            fatalError("BASE_URL is not set in configuration")
        }
        return url
    }

    var path: String {
        switch self {
        case .searchShops:
            return "/gourmet/v1/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchShops:
            return .get
        }
    }

    var task: Task {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY is not set in configuration")
        }

        switch self {
        case let .searchShops(request):
            var parameters = request.asParameters
            parameters["key"] = apiKey
            parameters["format"] = "json"
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
