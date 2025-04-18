import Foundation
import Moya

enum ServiceAPI {
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
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var validationType: ValidationType { .successCodes }
}
