

import Alamofire
import Foundation

enum AdminRouter: URLRequestConvertible {
    case regist(username: String, name: String, password: String)

    // MARK: Internal

    var method: HTTPMethod {
        switch self {
        case .regist:
            return .post
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .regist:
            return "v1/auth/register"
        }
    }

    var parameters: Parameters {
        switch self {
        case let .regist(username, name, password):
            return ["username": username, "name": name, "password": password]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case let .regist(username, name, password):
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)

            return request
        }
    }
}
